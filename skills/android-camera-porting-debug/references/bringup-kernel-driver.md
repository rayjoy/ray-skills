# Bringup Kernel Driver

## Scope

Use this file for:

- sensor probe failure
- wrong sensor ID
- I2C read failure
- power sequence issues
- imgsensor registration issues

## Main Checks

1. Confirm sensor exists in sensor list.
2. Confirm power sequence and reset sequence.
3. Confirm MCLK and I2C bus/address.
4. Confirm expected sensor ID and retry behavior.
5. Confirm runtime probe logs before editing driver logic.

## Typical Symptoms

- sensor not found
- I2C ACK error
- read sensor id fail
- app cannot enumerate sensor because probe never succeeds

## Execution Rules

- Patch logs before changing probe flow.
- Do not mix bring-up fixes with metadata or tuning changes in the same step unless evidence forces it.
