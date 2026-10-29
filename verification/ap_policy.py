"""Small AP-side policy prototype for R2.3, not an optical or consensus defense.

The AP verifies an enrolled user's HMAC-authenticated request, freshness, nonce,
room bounds and a sliding request allowance before submitting a ledger batch.
Keys and the decision log are private AP inputs. Nonce sets are retained for
this finite experiment; a production service needs durable state and a bounded
nonce/epoch lifecycle. A compromised AP/key and multi-identity evasion remain.
"""
from collections import defaultdict,deque
import hashlib,hmac,json,math

def canonical(body):
    return json.dumps(body,sort_keys=True,separators=(',',':'),allow_nan=False).encode()

def sign(body,key):
    return {'body':body,'tag':hmac.new(key,canonical(body),hashlib.sha256).hexdigest()}

class APPolicy:
    def __init__(self,keys,limit=3,window_s=10,freshness_s=30):
        if limit<1 or round(window_s*1000)<1 or round(freshness_s*1000)<1:raise ValueError('Invalid policy')
        self.keys=keys;self.limit=limit;self.window=window_s;self.freshness=freshness_s
        self.nonces=defaultdict(set);self.accepted=defaultdict(deque);self.last_time=-math.inf

    def evaluate(self,request,now):
        if not math.isfinite(now) or now<self.last_time:raise ValueError('Nonmonotonic AP time')
        self.last_time=now
        now_ms=round(now*1000)
        if not isinstance(request,dict):return False,'malformed_request'
        body=request.get('body',{})
        if not isinstance(body,dict):return False,'malformed_request'
        uid=body.get('user_id');tag=request.get('tag','')
        if not isinstance(uid,str) or uid not in self.keys:return False,'unknown_identity'
        try:expected=hmac.new(self.keys[uid],canonical(body),hashlib.sha256).hexdigest()
        except (TypeError,ValueError):return False,'malformed_request'
        try:tag_bytes=bytes.fromhex(tag) if isinstance(tag,str) else b''
        except ValueError:tag_bytes=b''
        if len(tag_bytes)!=32 or not hmac.compare_digest(bytes.fromhex(expected),tag_bytes):return False,'authentication'
        issued=body.get('issued_ms');nonce=body.get('nonce');position=body.get('position')
        if not isinstance(issued,int) or isinstance(issued,bool) or issued<now_ms-round(self.freshness*1000) or issued>now_ms+round(self.freshness*1000):return False,'freshness'
        if not isinstance(nonce,int) or isinstance(nonce,bool) or nonce<0:return False,'invalid_nonce'
        if not isinstance(position,list) or len(position)!=3:return False,'invalid_position'
        if any(not isinstance(x,(int,float)) or isinstance(x,bool) or x<0 or x>upper or not math.isfinite(x)
               for x,upper in zip(position,[10,10,3])):return False,'invalid_position'
        if nonce in self.nonces[uid]:return False,'replay'
        # Consume an authenticated nonce even when throttled, preventing retries
        # from turning the same signed request into fresh work after the window.
        self.nonces[uid].add(nonce)
        history=self.accepted[uid]
        # Protocol timestamps are integer milliseconds; avoid floating-point
        # boundary errors that otherwise throttle a legitimate periodic user.
        while history and history[0]<=now_ms-round(self.window*1000):history.popleft()
        if len(history)>=self.limit:return False,'rate_limit'
        history.append(now_ms)
        return True,'accepted'
