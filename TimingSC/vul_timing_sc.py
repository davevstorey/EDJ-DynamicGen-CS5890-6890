import time

def insecureStringCompare(instr: str) -> bool:
    secret = "secret"
    for i in range(len(secret)):  
        if secret[i] != instr[i]:
            return False
        time.sleep (0.01)
    return True