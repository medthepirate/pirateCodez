import java.util.*;
import java.io.*;
import java.nio.file.*;

/////////////////////////////////////////////////////////////////////////////////
// This implementation of the quicksort algorithm starts by demonstrating with a
// premade array and then asks for input from the user. It was written by
// Andrew Medland, April 2014
/////////////////////////////////////////////////////////////////////////////////

public class Quicksort{
	
    private int[] sortArray; 									//create the array to be sorted
    private int num; 											// initiate the length of the array int
    private String prtStr;										// initiate the string that the array is parsed to for printing
	private int indices;										// initiate the int for the length of any custom arrays entered
	private Scanner newArray = new Scanner(System.in);			// input taking
	private Scanner newFilePath = new Scanner(System.in);		// input taking
    private String filePath; 									// for opening .txt files for reading
	private String thisLine;
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// MAIN
	//////////////////////////////////////////////////////////////////////////////////////////////
    public static void main(String[] args) {	
		long rTimeM, sTimeM;
        boolean fl = true;
        int[] assignment3 = {5,1,2,3,12,20,30,6,14,1,0}; 		// the first array we want to sort
		
		System.out.println("\n=====================================================================\nWelcome to MedSort, your friendly quicksort implementation. \n=====================================================================\n\nHere is a little demo:");
        sTimeM = System.nanoTime();								//get the start time
		Quicksort ms = new Quicksort(assignment3); 					//create an instance of the class and construct it with arguments 
		rTimeM = System.nanoTime() - sTimeM; 					// calculate the run time
		System.out.println(Arrays.toString(ms.sortArray));
		System.out.println("\nThis took " + rTimeM + " nanoseconds to compute"); // print out the run time
		while(fl){ ms.choose();}

	}
   
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Constructors
	//////////////////////////////////////////////////////////////////////////////////////////////
	public Quicksort(){} 							// without arguments

    public Quicksort(int[] a){	 				// with arguments
		init(a);
    }
	
	private void init(int[] a){ 				// with arguments
        
        if(a == null || a.length == 0){			//check for a valid array
            return;
        }
        
        this.sortArray = a;						// assign this objects array to the one passed to the constructor
       
        this.num = sortArray.length; 			// find its length
        qSort(0, num-1);

    }
	
    ///////////////////////////////////////////////////////////////////////////////////
    //partition function
	///////////////////////////////////////////////////////////////////////////////////
    private void qSort(Integer loNum, Integer hiNum){
       
        prtStr = Arrays.toString(sortArray);	//parse the array to a string
        System.out.println(prtStr); 			// print it to the console
        
        int l = loNum;							// assign the left and right compare values to the ones passed to the method
        int r = hiNum;

        Integer indP = (loNum + hiNum)/2;
        Integer p = sortArray[indP];
		
       
        while(l<=r){  							// Divide into lists either side of the pivot
			
            
            while(sortArray[l] < p){			// while the value to the left of p is < p increment it
                l++;
            }
            
            while(sortArray[r] > p){			// while the value to the right of p is > p decrement it
                r--;
            }
           
            if(l<=r){ 							// after they find a match switch them provided l and r are the correct way round, inc/dec l and r
				if (sortArray[l] == sortArray[r]) break;
                switchNums(l, r);
                l++;
                r--;
            }
        }

       
        if(loNum<r){ 							// next partition phase (recursion)
            qSort(loNum, l - 1);
        }
        if(l<hiNum){
            qSort(r + 1, hiNum);
        }
    }
	
	///////////////////////////////////////////////////////////////////////////////////////////
    //swap function
	///////////////////////////////////////////////////////////////////////////////////////////
    private void switchNums(int l, int r){
        int temp = sortArray[l];
        sortArray[l] = sortArray[r];
        sortArray[r] = temp;
    }
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// input taking
	////////////////////////////////////////////////////////////////////////////////////////////
	public int getArrayLength(){
		System.out.println("\nNow let's do one of yours. How many items in your array?");
		if(newArray.hasNextInt()){
			indices = newArray.nextInt();		
		}
		return indices;
	}
	
	public void getArray(int numOfInd){
	
		int[] lnArray = new int[numOfInd]; 			//give sort Array a new length
		sortArray = lnArray;
		System.out.println("\nPlease enter the array one number at a time");
		for(int i = 0; i<numOfInd; i++){
			Scanner sc = new Scanner(System.in);
			if(sc.hasNextInt()){
				sortArray[i] = sc.nextInt();
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Read from a file
	//////////////////////////////////////////////////////////////////////////////////////////////
	public void openFile(String filePath){
		
		ArrayList al = new ArrayList(); 			// use an array list because we don't know how many lines are in the file
		
		System.out.println("\nWhat's the path for your .txt file (omit the '.txt')?");
		if(newFilePath.hasNextLine()){
			filePath = newFilePath.nextLine();		
		}
		
		try{
			BufferedReader r = new BufferedReader(new FileReader(filePath + ".txt"));

			int j = 0;
			while((thisLine = r.readLine())!=null){
				System.out.println(thisLine);
				al.add(j, (Integer.parseInt(thisLine)));
				j++;
			}
			r.close();
		}
		catch(IOException e){
			System.out.println("IOException: " + e);
			System.exit(0);
		}
		int[] tempArr = new int[al.size()];
		for(int i = 0; i < tempArr.length; i++){
			tempArr[i] = (Integer) al.get(i); 			// assign the arraylist elements to the newly sized temp array for the partition method to use
		}
		init(tempArr);

	}

	//////////////////////////////////////////////////////////////////////////////////////////////
	// let the user choose how to get the array to sort
	//////////////////////////////////////////////////////////////////////////////////////////////
	public void choose(){
	
		boolean flag = true;
		int choice = 0;
		long sTime, rTime;
		
		while(flag){
		System.out.println("\nplease choose\n\n1) Enter the array in the console\n2) open a file with an array in (separated by lines)\n3) exit");
		Scanner choiceSc = new Scanner(System.in);
		if(choiceSc.hasNextInt()){
			choice = choiceSc.nextInt();
		}
		switch(choice){
			case 1:
				Quicksort msSC = new Quicksort(); 					//create an instance without arguments
				msSC.getArrayLength(); 							//set the length of the array
				msSC.getArray(msSC.indices); 					//input the array
				sTime = System.nanoTime();						//get the start time
				msSC.init(msSC.sortArray); 						// run the sorting method on your new array	
				System.out.println(Arrays.toString(msSC.sortArray));
				rTime = System.nanoTime() - sTime; 				// calculate the run time
				System.out.println("\nThis took " + rTime + " nanoseconds to compute.\n\n=====================================================================\nThanks for using 'Quicksort'. There's cake, so you could have cake or choose from the following:\n=====================================================================\n"); // print out the run time
				return;
			case 2:
				Quicksort msIO = new Quicksort(); 					//create an instance without arguments
				sTime = System.nanoTime();						//get the start time	
				msIO.openFile(msIO.filePath); 								// start the dialog to open your file
				System.out.println(Arrays.toString(msIO.sortArray));
				rTime = System.nanoTime() - sTime; 				// calculate the run time
				System.out.println("\nThis took " + rTime + " nanoseconds to compute.\n\n=====================================================================\nThanks for using 'MedSort'. There's cake, so you could have cake or choose from the following:\n=====================================================================\n"); // print out the run time
				return;
			case 3:
				System.out.println("\n=====================================================================\nThanks for using 'MedSort'. Now have Cake!\n=====================================================================\n");
				System.exit(0);
			default:
				System.out.println("try again!");
				
		}
		
	}
	
}
}