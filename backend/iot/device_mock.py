import requests
import time
import json

# Configuration
API_URL = "https://ihnvropaqzmjxikxgggd.supabase.co/functions/v1/validate-qr"
API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlobnZyb3BhcXptanhpa3hnZ2dkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzMTIxMjIsImV4cCI6MjA4NTg4ODEyMn0.YQAo2wx4SnBqFQuvgB5xzOf7ycYaiZxtvxaWUdj09IE" # Using Anon Key

def activate_motor(slot_id):
    """
    Simulates motor control. 
    In real hardware: GPIO.output(pins[slot_id], GPIO.HIGH)
    """
    print(f"\n[HARDWARE] >>> Dispensing from SLOT {slot_id}...")
    time.sleep(2) # Simulate motor running
    print(f"[HARDWARE] >>> Item dispensed! \n")

def scan_qr():
    """
    Simulates scanning a QR code.
    In real hardware: Setup camera, use OpenCV/pyzbar to read frame.
    """
    print("Waiting for QR Scan... (Enter token manually for test)")
    return input("QR Token: ")

def main():
    print("--- Vending Machine IoT System Started (MOCK MODE) ---")
    
    while True:
        try:
            qr_token = scan_qr()
            if not qr_token: continue

            print(f"Validating Token: {qr_token}...")
            
            # MOCK VALIDATION - bypassing Supabase Edge Function
            # In real implementation, this would call the API
            if qr_token.startswith('mock-secure-token-'):
                # Simulate successful validation
                print("✅ Validation Successful (MOCK)")
                print(f"Product: Mock Product")
                # Extract a slot number from the token timestamp (1-3)
                slot = (int(qr_token.split('-')[-1]) % 3) + 1
                activate_motor(slot)
            else:
                print("❌ Invalid token format (expected mock-secure-token-*)")

        except Exception as e:
            print(f"System Error: {e}")
            
        print("-" * 30)

if __name__ == "__main__":
    main()
