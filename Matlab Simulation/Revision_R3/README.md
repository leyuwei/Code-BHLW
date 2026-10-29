# Native MATLAB reproduction

Run `run_revision_suite` to regenerate the current response's seeded communication studies. It calls the retained R25/R26 kernels and the current R32 coordination-failure runner. Outputs are written to this directory's `results/`; the complete integration instructions and parameter map are in the repository's `REVISION_R3.md`.

`r27/simulate_paper_matched27.m` is the current service kernel. Requests keep their positions until completion or rejection, use 1--10 Gbit payloads, check nearest-LD occupancy before coverage, and retain accepted unfinished requests in FIFO queues. `r27/warp_blocks27.m` accounts for the interrupted mining peer's lost hash power.

`r32/run_response32.m` reproduces the four table fractions 0, 0.1, 0.7 and 0.8 and the 0.8 figure's fourteen request frequencies. The runner generates 255 cases using five common input tapes. The preceding stages regenerate those tapes, the corrected 10.8 Gbit/s WiFi reference, correlation sensitivity and confirmation/capacity results.

Use `plot_revision.py` after the AP sweep to generate the current four figure types as vector PDF/SVG and PNG. The repository's `verification/verify_matlab.py` and `verify_service_traces.py` compare saved numerical values and independently check the request traces.
