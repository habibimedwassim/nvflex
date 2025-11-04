#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nvflux.h"

static int expect(int cond, const char *msg) {
    if (!cond) {
        fprintf(stderr, "FAIL: %s\n", msg);
        return 1;
    }
    return 0;
}

int main(void) {
    int errors = 0;

    // basic parse test: unsorted input -> expect descending sorted output
    const char *txt = "3000\n7000,5000\n";
    int clocks[16] = {0};
    int n = nvflux_parse_clocks(txt, clocks, 16);
    errors += expect(n == 3, "parse count should be 3");
    errors += expect(clocks[0] == 7000, "largest should be first (7000)");
    errors += expect(clocks[1] == 5000, "second should be 5000");
    errors += expect(clocks[2] == 3000, "third should be 3000");

    // boundary test: empty input
    int clocks2[4] = {0};
    n = nvflux_parse_clocks("", clocks2, 4);
    errors += expect(n == 0, "empty input -> 0 clocks");

    return errors ? EXIT_FAILURE : EXIT_SUCCESS;
}