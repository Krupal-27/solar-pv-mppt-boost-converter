#ifndef MPPT_PO_H
#define MPPT_PO_H

/**
 * MPPT Perturb & Observe Algorithm
 * Header file
 */

// Function prototypes
float mppt_po(float V_current, float I_current);
void mppt_reset(void);

#endif /* MPPT_PO_H */