package sg.edu.nus.cs2020.ps3;
import java.util.List;

/**
 * Interface for a runway scheduler
 */
public interface IRunwayScheduler{
	public boolean requestTimeSlot(int time, String pilot);
	public int getNextFreeSlot(int time);
	public int getNextPlane(int time);
	public String getPilot(int time);
	public List<String> getPilots();
	public List<Integer> getPilotSchedule(String pilot);
}
