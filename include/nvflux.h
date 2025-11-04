#ifndef NVFLUX_H
#define NVFLUX_H

/* Public API used by main and tests */
int nvflux_run(int argc, char **argv);
int nvflux_parse_clocks(const char *txt, int *clocks, int max);

#endif // NVFLUX_H