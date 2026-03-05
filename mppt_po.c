

#include "mppt_po.h"

// MPPT parameters
#define STEP_SIZE   0.01f   // Duty cycle step size (1%)
#define DUTY_MIN    0.10f    // Minimum duty cycle (10%)
#define DUTY_MAX    0.90f    // Maximum duty cycle (90%)
#define DUTY_INIT   0.50f    // Initial duty cycle (50%)

// Static variables (persistent between calls)
static float V_prev = 0.0f;
static float P_prev = 0.0f;
static float duty_prev = DUTY_INIT;

/**
 * MPPT Perturb & Observe Function
 * @param V_current: Current PV voltage (Volts)
 * @param I_current: Current PV current (Amps)
 * @return: New duty cycle (0.1 to 0.9)
 */
float mppt_po(float V_current, float I_current) {
    float P_current;      // Current power
    float duty_new;       // New duty cycle to return
    
    // Calculate current power
    P_current = V_current * I_current;
    
    // Perturb & Observe algorithm
    if (P_current > P_prev) {
        // Power increased - continue same direction
        if (V_current > V_prev) {
            duty_new = duty_prev + STEP_SIZE;
        } else {
            duty_new = duty_prev - STEP_SIZE;
        }
    } else {
        // Power decreased - reverse direction
        if (V_current > V_prev) {
            duty_new = duty_prev - STEP_SIZE;
        } else {
            duty_new = duty_prev + STEP_SIZE;
        }
    }
    
    // Limit duty cycle to safe range
    if (duty_new < DUTY_MIN) {
        duty_new = DUTY_MIN;
    }
    if (duty_new > DUTY_MAX) {
        duty_new = DUTY_MAX;
    }
    
    // Update persistent values for next call
    V_prev = V_current;
    P_prev = P_current;
    duty_prev = duty_new;
    
    return duty_new;
}

/**
 * Reset MPPT algorithm (optional)
 * Call this when starting new session
 */
void mppt_reset(void) {
    V_prev = 0.0f;
    P_prev = 0.0f;
    duty_prev = DUTY_INIT;
}