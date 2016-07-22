
/**
 * This class is used to store and retrieve the distance between various locations 
 * A route is assumed to be bidirectional. i.e., a route from CityA to CityB is 
 * same as a route from CityB to CityA. Furthermore, there can be no more than 
 * one route between two locations. Deleting a route is not supported at this point.
 * The storage limit for this version is 10 routes.
 * In the case more than multiple routes between the same two locations were entered,
 * we store only the latest one. The command format is given by the example interaction below:

Welcome to SimpleRouteStore!
Enter command:addroute Clementi BuonaVista 12
Route from Clementi to BuonaVista with distance 12km added
Enter command:getdistance Clementi BuonaVista
Distance from Clementi to BuonaVista is 12
Enter command:getdistance clementi buonavista
Distance from clementi to buonavista is 12
Enter command:getdistance Clementi JurongWest
No route exists from Clementi to JurongWest!
Enter command:addroute Clementi JurongWest 24
Route from Clementi to JurongWest with distance 24km added
Enter command:getdistance Clementi JurongWest
Distance from Clementi to JurongWest is 24
Enter command:exit

 * @author Dave Jun
 */

import java.util.Scanner;

public class CityConnect {
	
	/* ==============NOTE TO STUDENTS======================================
	 * These messages shown to the user are defined in one place for 
	 * convenient editing and proof reading. Such messages are considered 
	 * part of the UI and may be subjected to review by UI experts or
	 * technical writers.
	 * Note that Some of the strings below include '%1$s' etc to mark the 
	 * locations at which java String.format(...) method can insert values.  
	 * ====================================================================
	 */
	private static final String MESSAGE_DISTANCE = "Distance from %1$s to %2$s is %3$s";
	private static final String MESSAGE_NO_ROUTE = "No route exists from %1$s to %2$s!";
	private static final String MESSAGE_ADDED = "Route from %1$s to %2$s with distance %3$skm added";
	private static final String MESSAGE_INVALID_FORMAT = "invalid command format :%1$s";
	private static final String MESSAGE_WELCOME = "Welcome to SimpleRouteStore!";
	private static final String MESSAGE_NO_SPACE = "No more space to store locations";
	
	//These are the possible command types 
	enum COMMAND_TYPE {ADD_ROUTE, GET_DISTANCE, INVALID, EXIT};
	
	//This is used to indicate that the 'route not yet found' condition
	private static final int NOT_FOUND = -1;
	
	//These are the correct number of parameters for each command
	private static final int PARAM_SIZE_ADD_ROUTE = 3;
	private static final int PARAM_SIZE_GET_DISTANCE = 2;
	
	//These are the locations at which various parameters will appear in a command
	private static final int PARAM_POSITION_START_LOCATION = 0;
	private static final int PARAM_POSITION_END_LOCATION = 1;
	private static final int PARAM_POSITION_DISTANCE = 2;
	
	//This program can store only a up to a fixed number of routes
	private static final int MAX_ROUTES = 10;
	
	//This array will be used to store the routes
	static String[][] routes = new String[MAX_ROUTES][3];
	
	/*These are the locations at which various components of the route will
	 * be stored in the routes[][] array. TODO: check: is it necessary to make it a ENUM?
	 */
	private static final int STORAGE_POSITION_START_LOCATION = 0;
	private static final int STORAGE_POSITION_END_LOCATION = 1;
	private static final int STORAGE_POSITION_DISTANCE = 2;
	
	/*This variable is declared for the whole class (instead of declaring it 
	 * inside the readUserCommand() method
	 * to facilitate automated testing using the I/O redirection technique. 
	 * If not, only the first line of the input text file will be processed.
	 */
	static Scanner scanner = new Scanner(System.in); 
	
	/* ==============NOTE TO STUDENTS======================================
	 * Notice how this method solves the whole problem at a very high level. 
	 * We can understand the high-level logic of the program by reading 
	 * this method alone. 
	 * ====================================================================
	 */
	public static void main(String[] args) {
		showToUser(MESSAGE_WELCOME);
		interactWithUser();
	}

	/* ==============NOTE TO STUDENTS======================================
	 * If the reader wants a deeper understanding of the solution, he/she 
	 * can go to the next level of abstraction by reading the five methods
	 * (given below) that is referenced by the method above. 
	 * ====================================================================
	 */

	private static void showToUser(String text) {
		System.out.println(text);
	}
	
	private static void interactWithUser(){
		while(true){
			String userCommand = readUserCommand();
			String feedback = executeCommand(userCommand);
			showToUser(feedback);	
		}
	}

	private static String readUserCommand() {
		System.out.print("Enter command:");
		String command = scanner.nextLine();
		return command;
	}

	public static String executeCommand(String userCommand) {
		if(userCommand.trim().equals(""))
			return String.format(MESSAGE_INVALID_FORMAT,userCommand); 
		
		String commandTypeString = getHead(userCommand);
		
		COMMAND_TYPE commandType = determineCommandType(commandTypeString);
		switch(commandType){
		case ADD_ROUTE: 
			return addRoute(userCommand);
		case GET_DISTANCE: 
			return getDistance(userCommand);
		case INVALID: 
			return String.format(MESSAGE_INVALID_FORMAT, userCommand); 
		case EXIT:
			System.exit(0);
		default:
			throw new Error("Unrecognized command type");
		}
		/* ==============NOTE TO STUDENTS==================================
		 * If the rest of the program is correct, this error will never be
		 * thrown. That is why we use an Error instead of an Exception. 
		 * ================================================================
		 */
	}

	
	/* ==============NOTE TO STUDENTS======================================
	 * After reading the above code, the reader should have a reasonable
	 * understanding of how the program works. If the reader wants to go 
	 * EVEN more deep into the solution, he/she can read the methods given 
	 * below that solves various sub-problems at lower levels of abstraction. 
	 * ====================================================================
	 */
	
	/**
	 * This operation determines which of the supported command types the 
	 * user wants to perform
	 * @param commandTypeString is the first word of the user command
	 */
	private static COMMAND_TYPE determineCommandType(String commandTypeString) {
		if(commandTypeString==null)
			throw new Error("command type string cannot be null!");
		
		if(commandTypeString.equalsIgnoreCase("addroute")) 
			return COMMAND_TYPE.ADD_ROUTE;
		else if (commandTypeString.equalsIgnoreCase("getdistance")) 
			return COMMAND_TYPE.GET_DISTANCE;
		else if (commandTypeString.equalsIgnoreCase("exit")) 
			return COMMAND_TYPE.EXIT;
		else 
			return COMMAND_TYPE.INVALID;
	}
	
	/**
	 * This operation is used to find the distance between two locations
	 * @param userCommand is the full string user has entered as the command 
	 * @return the distance
	 */
	private static String getDistance(String userCommand) {
		String[] parameters = (removeFirstWord(userCommand)).trim().split("\\s+");
		if(parameters.length<PARAM_SIZE_GET_DISTANCE)
			return String.format(MESSAGE_INVALID_FORMAT, userCommand);
		
		String newStartLocation = parameters[PARAM_POSITION_START_LOCATION];
		String newEndLocation = parameters[PARAM_POSITION_END_LOCATION];
		
		for (int i = 0; i < routes.length; i++) {
			
			String existingStartLocation = routes[i][STORAGE_POSITION_START_LOCATION];
			String existingEndLocation = routes[i][STORAGE_POSITION_END_LOCATION];
			
			if (existingStartLocation==null)continue; //empty slot
			else if (isSameRoute(existingStartLocation, existingEndLocation, 
					newStartLocation, newEndLocation)){	//route found
				return String.format(MESSAGE_DISTANCE,newStartLocation,
						newEndLocation,routes[i][STORAGE_POSITION_DISTANCE]);
			} 
		}
		
		return String.format(MESSAGE_NO_ROUTE,newStartLocation,newEndLocation);
		
	}

	/**
	 * This operation adds a route to the storage. If the route already exists, 
	 * it will be overwritten. 
	 * @param userCommand (although we receive the full user command, we assume 
	 * without checking the first word to be 'addroute')
	 * @return status of the operation
	 */
	private static String addRoute(String userCommand) {
		String[] parameters = (removeFirstWord(userCommand)).trim().split("\\s+");
		if(parameters.length<PARAM_SIZE_ADD_ROUTE)
			return String.format(MESSAGE_INVALID_FORMAT, userCommand);
		
		String newStartLocation = parameters[PARAM_POSITION_START_LOCATION];
		String newEndLocation 	= parameters[PARAM_POSITION_END_LOCATION];
		String distance 		= parameters[PARAM_POSITION_DISTANCE];
		
		if(!isPositiveNonZeroInt(distance)) 
			return String.format(MESSAGE_INVALID_FORMAT, userCommand);
		
		int entryPosition = NOT_FOUND;
		
		for (int i = 0; i < routes.length; i++) {
			
			String existingStartLocation = routes[i][STORAGE_POSITION_START_LOCATION];
			String existingEndLocation = routes[i][STORAGE_POSITION_END_LOCATION];
			
			if (existingStartLocation==null) { //empty slot 
				/*if this is the first empty slot found, we mark is as a possible 
				 * entry position. Note that if the route does not exist, it will be 
				 * stored in the first empty slot of the storage.)
				 */
				if(entryPosition == NOT_FOUND)entryPosition = i;
				else continue;
			//not empty; check if it is the route we have been looking for
			}else  if (isSameRoute(existingStartLocation, existingEndLocation, 
											newStartLocation, newEndLocation)){
				entryPosition = i;
				break;
			} 
		}
		
		//route not found, no empty slots either
		if(entryPosition==NOT_FOUND)return MESSAGE_NO_SPACE;
		
		routes[entryPosition][STORAGE_POSITION_START_LOCATION]=newStartLocation;
		routes[entryPosition][STORAGE_POSITION_END_LOCATION]=newEndLocation;
		routes[entryPosition][STORAGE_POSITION_DISTANCE]=distance;
		
		return String.format(MESSAGE_ADDED, newStartLocation, newEndLocation, distance);
	}
	
	/**
	 * This operation checks if two routes represents the same route. 
	 * @return
	 */
	private static boolean isSameRoute(String startLocation1, String endLocation1,
			String startLocation2, String endLocation2) {
		
		if((startLocation1==null)||(endLocation1==null)
				&&(startLocation2==null)||(endLocation2==null))
			throw new Error("Route end points cannot be null");
		
		return (startLocation1.equalsIgnoreCase(startLocation2)
					&& endLocation1.equalsIgnoreCase(endLocation2))
				||(startLocation1.equalsIgnoreCase(endLocation2) 
					&& endLocation1.equalsIgnoreCase(startLocation2));
	}

	private static boolean isPositiveNonZeroInt(String s) {
		try {
			int i = Integer.parseInt(s);
			return (i>0?true:false);
		} catch (NumberFormatException nfe) {
			return false;
		}
	}
	
	private static String removeFirstWord(String userCommand) {
		return userCommand.replace(getHead(userCommand), "").trim();
	}

	private static String getHead(String userCommand) {
		String commandTypeString = userCommand.trim().split("\\s+")[0];
		return commandTypeString;
	}
}
