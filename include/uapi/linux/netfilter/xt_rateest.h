/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
#ifndef _XT_RATEEST_MATCH_H
#define _XT_RATEEST_MATCH_H

#include <linux/types.h>
#include <linux/if.h>

enum xt_rateest_match_flags {
    XT_RATEEST_MATCH_INVERT = 1 << 0,
    XT_RATEEST_MATCH_ABS    = 1 << 1,
    XT_RATEEST_MATCH_REL    = 1 << 2,
    XT_RATEEST_MATCH_DELTA  = 1 << 3,
    XT_RATEEST_MATCH_BPS    = 1 << 4,
    XT_RATEEST_MATCH_PPS    = 1 << 5,
};

struct xt_rateest_match_info {
    char name1[IFNAMSIZ];
    char name2[IFNAMSIZ];
    __u16 bps1;
    __u16 pps1;
    __u16 bps2;
    __u16 pps2;
    __u8 cmp;
    __u8 flags;
};

#endif /* _XT_RATEEST_MATCH_H */
