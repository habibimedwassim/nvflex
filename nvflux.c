#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <ctype.h>
#include <sys/wait.h>

#define MAX_CLOCKS 128
#define READ_BUF 4096

static const char *allowed_cmds[] = {
    "performance", "balanced", "powersaver", "auto", "reset", "status", "clock", "--restore", NULL
};

static char nvsmipath[512] = {0};

static int find_nvidia_smi(void) {
    const char *candidates[] = {
        "/usr/bin/nvidia-smi",
        "/usr/local/bin/nvidia-smi",
        NULL
    };

    for (int i = 0; candidates[i]; ++i) {
        if (access(candidates[i], X_OK) == 0) {
            snprintf(nvsmipath, sizeof(nvsmipath), "%s", candidates[i]);
            return 0;
        }
    }

    const char *path = getenv("PATH");
    if (!path) return -1;

    char tmp[512];
    snprintf(tmp, sizeof(tmp), "%s", path);

    for (char *tok = strtok(tmp, ":"); tok; tok = strtok(NULL, ":")) {
        char candidate[512];
        snprintf(candidate, sizeof(candidate), "%s/nvidia-smi", tok);
        if (access(candidate, X_OK) == 0) {
            snprintf(nvsmipath, sizeof(nvsmipath), "%s", candidate);
            return 0;
        }
    }

    return -1;
}