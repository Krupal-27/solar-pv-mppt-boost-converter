/*
 * Example usage of MPPT algorithm
 * Simulated PV system with boost converter
 */

#include <stdio.h>
#include <stdlib.h>
#include "mppt_po.h"

// Simulated ADC readings (replace with actual hardware)
float read_voltage(void) {
    // Simulate voltage reading around 23.5V
    return 23.5f + ((rand() % 100) - 50) / 100.0f;
}

float read_current(void) {
    // Simulate current reading around 0.17A
    return 0.17f + ((rand() % 100) - 50) / 1000.0f;
}

void set_pwm_duty(float duty) {
    // Send duty cycle to PWM hardware
    printf("PWM Duty: %.3f (%.1f%%)\n", duty, duty * 100);
}

int main() {
    float V, I, duty;
    int i;
    
    printf("MPPT Perturb & Observe Algorithm Test\n");
    printf("======================================\n\n");
    
    // Initialize MPPT
    mppt_reset();
    
    // Run for 20 iterations
    for (i = 0; i < 20; i++) {
        // Read sensors
        V = read_voltage();
        I = read_current();
        
        // Calculate new duty cycle
        duty = mppt_po(V, I);
        
        // Apply to PWM
        set_pwm_duty(duty);
        
        // Print readings
        printf("Step %2d: V=%.2fV, I=%.3fA, P=%.2fW, Duty=%.3f\n", 
               i+1, V, I, V*I, duty);
        
        // Small delay (simulated)
        // In real system: wait for next sampling period
    }
    
    return 0;
}
