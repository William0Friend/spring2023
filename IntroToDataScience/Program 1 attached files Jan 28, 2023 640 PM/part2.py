
# your code below
import os
import glob

#go to program #1's directory
#unzip flower data


#print(os.listdir())

#change to flowers directory
print(os.getcwd())
print(os.listdir())

flowers = os.chdir('flowers')
print(os.getcwd())
sub_flowers = os.chdir('flowers')
flower_types  = []
subdirs = []
#get the subdirectory
for folder in glob.glob('*'):
    subdirs.append(folder)
   #print(folder)
   #print(os.getcwd())
    i = 1
    #move back up one
    
    flower_types.append(folder)  
    
    os.chdir(folder)
    for image in glob.glob('*.png'):
        print(image)
       #still needs leading zeros 
        num_digits = 7
        #result = "{:0{}d}".format(count, num_digits)
        #print(result)
        #os.rename(image, f"{flower_types}_{i}.png")
        #os.rename(image, f"{flower_types}_{i}.png")
        result = "{}_{:0{}d}".format(flower_types,i, num_digits)

        #i += 1
    os.chdir('..')
print(subdirs)      

