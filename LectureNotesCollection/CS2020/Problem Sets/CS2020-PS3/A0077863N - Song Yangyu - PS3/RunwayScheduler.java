/*	Overall Design:
 * I used the idea of hashing: 
 * 	1. for every input, it's inserted to an array with index i
 *  2. I use a "int table[10080]" to store the index of the data of the corresponding time; 
 *  3.  		Information on this (int) time array:
	 * 1. the index is the entering time
	 * 2. value is the index of the plane of this corresponding time
	 *   a) if value==0, means this time can be chosen as a new landing time
	 *   b) if value==-1, means though no plane is landing at this time, but it's very
	 *   	 near (less than 2 minutes) to the landing time of another plane
	 *   c) the positive value stands for the index of the plane, in the List 'plane'
	 * 3. range: 0~10079. the maximum is 10079, since counting starts form 0  
 * 	4. In addition, there's another list to store all the names & flying time of the pilot
 * 	
 * 	5. Further improvement can be made:
 	 *  1. Actually I can sort them upon each insert, using insertion sort; 
 	 *  	(normally manually inserting data take lots of time, then it can use this time to
 	 *  		 sort)
 	 *     While if it's a huge data set input together, it's the best if we insert first and
 	 *     	then sort.
 	 *  2. When looking up the data/time/Pilot Name, I can use a binary search mechanism.  
 * */

package sg.edu.nus.cs2020.ps3;

import java.util.*;

class Plane implements Comparable<Plane>{
	int landingTime;
	String pilot;
	
	Plane(int landingTime, String pilotName){
		this.landingTime = landingTime;
		this.pilot = pilotName;
	}
	
	@Override
	public int compareTo(Plane b) {
		return this.landingTime - b.landingTime;
	}
}

class Pilot implements Comparable<Pilot>{
	String pilotName;
	int landingTime;
	
	Pilot(String pilotName, int landingTime){
		this.pilotName = pilotName;
		this.landingTime = landingTime;
	}
	
	@Override
	public int compareTo(Pilot b){
		return this.pilotName.compareToIgnoreCase(b.pilotName);
	}
}

public class RunwayScheduler implements IRunwayScheduler{
	
	/* 		Information on this (int) time array:
	 * 1. the index is the entering time
	 * 2. value is the index of the plane of this corresponding time
	 *   a) if value==0, means this time can be chosen as a new landing time
	 *   b) if value==-1, means though no plane is landing at this time, but it's very
	 *   	 near (less than 2 minutes) to the landing time of another plane
	 *   c) the positive value stands for the index of the plane, in the List 'plane'
	 * 3. range: 0~10079. the maximum is 10079, since counting starts form 0  
	*/
	int[] time = new int[10080];
	Boolean sorted = true;	// true if the list of plane is sorted 
	Boolean pilotSorted = true;
	
	List<Plane> plane = new ArrayList<Plane>();
	List<Pilot> pilots = new ArrayList<Pilot>();
	
	
	/* Functionality: Insert the time slot into the array runway.
 	* Rule: 	the time must be of 3 distance to the other time
	* Return:	true if succeed, false otherwise
 	*/
	@Override
	public boolean requestTimeSlot(int time, String pilot) {
		if(this.time[time]==0){
			plane.add(new Plane(time,pilot));
			updateSurroundingTime(time);
			this.time[time]=plane.size();
			this.sorted=false;
			this.pilotSorted=false;
			return true;
		}
		return false;
	}
	
	/* Functionality:	this private method can update the surrounding elements of one 
	 * 					time point given 
	 * Return:			null.
	 */
	private void updateSurroundingTime(int time){
		int start= (time-2>0)?time-2:0;
		int end = (time+2<10080)?time+2:10079;
		for(int i=start;i<=end;i++)	if(i!=time)this.time[i]=-1;
	}
	
	// sort when necessary
	private void sortPlaneList(){
		if(sorted=true)	return;
		Collections.sort(this.plane);
		
		// after sorting, update the sorted times
		for(int i=0;i<this.plane.size();i++){
			this.time[this.plane.get(i).landingTime] = i+1;
		}

		// finally, reset the flag
		this.sorted = true;
	}
	
	
	/* Functionality: return a proper next time point according to the rule
	 * Return: if there's a property time, then just return it;
	 * 	while if there's not, then return -1.
	 */
	@Override	
	public int getNextFreeSlot(int time) {
		for(;time<10080;time++)	if(this.time[time]==0)return time;
		return -1;	// no proper next free slot
	}

	/* Functionality: 	for a given time, return the time next Plane after this time point
	 * Assumption:		the plane flying at this specific time point would not be considered as
	 * 					a next Plane
	 * Return: 			the time of the next plane; null(or -1, depends on runway.keySuccessor())
	 * 					 if there's	no next Plane
	 */
	@Override
	public int getNextPlane(int time) {
		if(!this.sorted)	this.sortPlaneList();
		// after sorting, find the successor
		int i;
		
		// can change the matching mechanism here to a binary search, but not necessarily to do this
		// because the array of plane is relatively small (less than 10080/3 = 3360)
		for(i=0;i<this.plane.size();i++){ 
			if(this.plane.get(i).landingTime>time)break;
		}
		return (i==this.plane.size())?-1:this.plane.get(i).landingTime;	// -1 means no next plane
	}

	/* Functionality: 	for a given time, return the name of next Pilot after this time point
	 * Assumption:		the pilot flying at this specific time point would not be considered as a 
	 * 					next Pilot
	 * Return:			the name of the next pilot; "no such pilot" if no one flying at that time
	 */
	@Override
	public String getPilot(int time) {
		if(this.time[time]>0)	return this.plane.get(this.time[time]).pilot;
		else return "no such pilot";	// there's no such pilot landing at that time
	}

	/* Functionality: return a list of pilots according to there name (in alphabetical order)
	 */
	@Override
	public List<String> getPilots() {
		if(!this.pilotSorted){
			Collections.sort(this.pilots);	// sort when necessary
			this.pilotSorted=true;
		}
		List<String> res = new ArrayList<String>();
		String currentName = null;
		for(Pilot currentPilot:this.pilots){
			if(currentName!=currentPilot.pilotName){
				currentName=currentPilot.pilotName;
				res.add(currentName);
			}
			else continue;
		}
		return res;
	}
	
	/* Functionality: for a given pilot name, return a list of its flying time
	 * Return: if pilot found, return this list; if not, return a null list
	 */
	@Override
	public List<Integer> getPilotSchedule(String pilot) {
		if(!this.pilotSorted){
			Collections.sort(this.pilots);	// sort when necessary
			this.pilotSorted=true;
		}
		List<Integer> res= new ArrayList<Integer>();
		int key;
		for(key=0;key<this.pilots.size();key++)	if(pilot == this.pilots.get(key).pilotName)	break;
		if(key==this.pilots.size()) return res;	// pilot not found
		while(pilot==this.pilots.get(key).pilotName){
			res.add(this.pilots.get(key).landingTime);key++;
		}
		return res;
	}
}
