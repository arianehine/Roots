from scipy import stats
from datetime import datetime
import random
import os
from faker import Faker
fake = Faker()



# average C02 footprint in grams
avgFtprint = 2200; 


def helper(remaining2):
    # HELPER FUNCTION FROM https://stackoverflow.com/questions/30004442/split-number-in-randomly-sized-portions-in-python
    num_containers = 3
    num_objects = round(remaining2*100);

    containers = [[] for _ in range(num_containers)]
    objects = (int for _ in range(num_objects))
    # we don't need a list of these, just have to iterate over it, so this is a genexp

    for object in objects:
        random.choice(containers).append(object)
    return containers;

def randomisedRatios():
     #Split up into fake components  (from GIN C PAPER) 
   #   Transport 
   #   Food & Drink 
   #   Clothing & Footwear
   #   Household, water, gas, electricity etc
   #   Health, Recreation, Etc  
   #   IN FUTURE GENERATE THESE VIA THE FORMULA GIVEN IN THE PAPER 

   #DIRECT HAS A HIGHER PRIORITY THAN INDIRECT (e.g prioritise household & transport)
   transport = round(random.uniform(0.25, 0.40), 2)
   remaining = 1 - transport
   household = round(random.uniform(0.25, 0.40), 2)
   remaining2 = remaining - household

  
   remainders = helper(remaining2)
   clothing = len(remainders[0]) / 100;
   food = len(remainders[1]) / 100;
   health = len(remainders[2]) / 100;

   return(transport, household, clothing, health, food)

def main():

    #Generate numbers from 2 S.Ds away from mean (2200)
    # N.B -1 and 1 = range in terms of SDs, may need to tweak as VARIANCE IS UNKNOWN
 
   path_to_script = os.path.dirname(os.path.abspath(__file__))
   f = open(os.path.join(path_to_script, 'synthesisedData.csv'), 'w+')
   f.write("ID, date, average, transport, household, clothing, health, food, transport_walking, transport_car, transport_train, transport_bus, transport_plane, household_heating, household_electricity, household_furnishings, household_lighting, clothing_fastfashion, clothing_sustainable, health_medicines, health_scans, food_meat, food_fish, food_dairy, food_oils\n")
   fake.date_time_between(start_date='-1y', end_date='now')

   for i in range (300):
    avg = stats.truncnorm.rvs(-1, 1, loc=2220, scale=50.0, size=2) 
    low = round(random.uniform(250, 1000), 2)
    high= round(random.uniform(250, 1000), 2)
    lowAvg = round((avgFtprint - low),2);
    highAvg = round((avgFtprint + high),2);
    ratios = randomisedRatios();
    transportAvg = round(avg[0]*ratios[0],2)
    transportRatio = transportRatios(transportAvg)
    householdAvg = round(avg[0]*ratios[1],2)
    householdRatio = householdRatios(householdAvg)
    clothingAvg = round(avg[0]*ratios[2],2)
    clothingRatio =  clothingRatios(clothingAvg)
    healthAvg = round(avg[0]*ratios[3],2)
    healthratio =  healthRatios(healthAvg)
    foodAvg = round(avg[0]*ratios[4],2)
    foodRatio =  foodRatios(foodAvg)

    
    
    toPrint = "average" + "," + str(fake.date_time_between(start_date='-1y', end_date='now')) + "," + str(round(avg[0],2)) + "," + str(round(avg[0]*ratios[0],2)) + "," + str(round(avg[0] * ratios[1],2)) + "," + str(round(avg[0] * ratios[2],2)) + "," + str(round(ratios[3]*avg[0],2))+ "," + str(round(ratios[4]*avg[0],2))+ "," + str(round(transportRatio[0]*transportAvg,2))+ "," + str(round(transportRatio[1]*transportAvg,2))+ "," + str(round(transportRatio[2]*transportAvg,2)) + "," + str(round(transportRatio[3]*transportAvg,2)) + "," + str(round(transportRatio[4]*transportAvg,2))+ "," + str(round(householdRatio[0]*householdAvg,2))+ "," + str(round(householdRatio[1]*householdAvg,2))+ "," + str(round(householdRatio[2]*householdAvg,2))+ "," + str(round(householdRatio[3]*householdAvg,2))+ "," + str(round(clothingRatio[0]*clothingAvg,2))+ "," + str(round(clothingRatio[1]*clothingAvg,2))+ "," + str(round(healthratio[0]*healthAvg,2))+ "," + str(round(healthratio[1]*healthAvg,2))+ "," + str(round(foodRatio[0]*foodAvg,2))+ "," + str(round(foodRatio[1]*foodAvg,2))+ "," + str(round(foodRatio[2]*foodAvg,2))+ "," + str(round(foodRatio[3]*foodAvg,2))
        
    f.write(toPrint)
    f.write("\n")

    ratios = randomisedRatios();
    transportAvg = round(highAvg*ratios[0],2)
    transportRatio = transportRatios(transportAvg)
    householdAvg = round(highAvg*ratios[1],2)
    householdRatio = householdRatios(householdAvg)
    clothingAvg = round(highAvg*ratios[2],2)
    clothingRatio =  clothingRatios(clothingAvg)
    healthAvg = round(highAvg*ratios[3],2)
    healthratio =  healthRatios(healthAvg)
    foodAvg = round(highAvg*ratios[4],2)
    foodRatio =  foodRatios(foodAvg)
        

    toPrint =  "high"  + "," + str(fake.date_time_between(start_date='-1y', end_date='now')) + "," + str(round(highAvg,2)) + "," + str(round(highAvg*ratios[0],2)) + "," + str(round(highAvg * ratios[1],2)) + "," + str(round(highAvg * ratios[2],2)) + "," + str(round(ratios[3]*highAvg,2))+ "," + str(round(ratios[4]*highAvg,2))+ "," + str(round(transportRatio[0]*transportAvg,2))+ "," + str(round(transportRatio[1]*transportAvg,2))+ "," + str(round(transportRatio[2]*transportAvg,2)) + "," + str(round(transportRatio[3]*transportAvg,2)) + "," + str(round(transportRatio[4]*transportAvg,2))+ "," + str(round(householdRatio[0]*householdAvg,2))+ "," + str(round(householdRatio[1]*householdAvg,2))+ "," + str(round(householdRatio[2]*householdAvg,2))+ "," + str(round(householdRatio[3]*householdAvg,2))+ "," + str(round(clothingRatio[0]*clothingAvg,2))+ "," + str(round(clothingRatio[1]*clothingAvg,2))+ "," + str(round(healthratio[0]*healthAvg,2))+ "," + str(round(healthratio[1]*healthAvg,2))+ "," + str(round(foodRatio[0]*foodAvg,2))+ "," + str(round(foodRatio[1]*foodAvg,2))+ "," + str(round(foodRatio[2]*foodAvg,2))+ "," + str(round(foodRatio[3]*foodAvg,2))
    f.write(toPrint)
    f.write("\n")

    ratios = randomisedRatios();
    transportAvg = round(lowAvg*ratios[0],2)
    transportRatio = transportRatios(transportAvg)
    householdAvg = round(lowAvg*ratios[1],2)
    householdRatio = householdRatios(householdAvg)
    clothingAvg = round(lowAvg*ratios[2],2)
    clothingRatio =  clothingRatios(clothingAvg)
    healthAvg = round(lowAvg*ratios[3],2)
    healthratio =  healthRatios(healthAvg)
    foodAvg = round(lowAvg*ratios[4],2)
    foodRatio =  foodRatios(foodAvg)



    toPrint =  "low" + ","  + str(fake.date_time_between(start_date='-1y', end_date='now')) + ","+ str(round(lowAvg,2)) + "," + str(round(lowAvg*ratios[0],2)) + "," + str(round(lowAvg * ratios[1],2)) + "," + str(round(lowAvg * ratios[2],2)) + "," + str(round(ratios[3]*lowAvg,2))+ "," + str(round(ratios[4]*lowAvg,2))+ "," + str(round(transportRatio[0]*transportAvg,2))+ "," + str(round(transportRatio[1]*transportAvg,2))+ "," + str(round(transportRatio[2]*transportAvg,2)) + "," + str(round(transportRatio[3]*transportAvg,2)) + "," + str(round(transportRatio[4]*transportAvg,2))+ "," + str(round(householdRatio[0]*householdAvg,2))+ "," + str(round(householdRatio[1]*householdAvg,2))+ "," + str(round(householdRatio[2]*householdAvg,2))+ "," + str(round(householdRatio[3]*householdAvg,2))+ "," + str(round(clothingRatio[0]*clothingAvg,2))+ "," + str(round(clothingRatio[1]*clothingAvg,2))+ "," + str(round(healthratio[0]*healthAvg,2))+ "," + str(round(healthratio[1]*healthAvg,2))+ "," + str(round(foodRatio[0]*foodAvg,2))+ "," + str(round(foodRatio[1]*foodAvg,2))+ "," + str(round(foodRatio[2]*foodAvg,2))+ "," + str(round(foodRatio[3]*foodAvg,2))
    f.write(toPrint)
    f.write("\n")

   f.close()

    #WRITE TO TEXT FILES
    
def transportRatios(transport):

    walking = round(random.uniform(0.1, 0.30), 2)
    remaining = 1 - walking
    driving = round(random.uniform(0.1, 0.30), 2)
    remaining = remaining - driving
    train = round(random.uniform(0.1, 0.20), 2)
    remaining = remaining - train

    remainders = helper(remaining)
    bus = len(remainders[0]) / 100;
    taxi = len(remainders[1]) / 100;
    plane = len(remainders[2]) / 100;
    
    #Split up into components  
    return(walking, driving, train, bus, taxi, plane)
  
def householdRatios(household):

    heating = round(random.uniform(0.1, 0.30), 2)
    remaining = 1 - heating 
    remainders = helper(remaining)
    electricity = len(remainders[0]) / 100;
    furnishing = len(remainders[1]) / 100;
    lighting = len(remainders[2]) / 100;
    
    #Split up into components  
    return(heating, electricity, furnishing, lighting)

def clothingRatios(clothing):

    fastfashion = round(random.uniform(0.5, 0.70), 2)
    sustainable = 1 - fastfashion 

    
    #Split up into components  
    return(fastfashion, sustainable)

def healthRatios(health):

    medicines = round(random.uniform(0.25, 0.75), 2)
    scans = 1 - medicines 

    
    #Split up into components  
    return(medicines, scans)

def foodRatios(food):

    meat = round(random.uniform(0.25, 0.75), 2)
    remainder = 1 - meat
    remainders = helper(remainder)
    fish = len(remainders[0]) / 100;
    dairy = len(remainders[1]) / 100;
    oils = len(remainders[2]) / 100;


    
    #Split up into components  
    return(meat, fish, dairy, oils)



if __name__ == "__main__":
    main()


