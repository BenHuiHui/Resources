package sg.edu.nus.cs2020;

public class DocumentDistanceMain 
{

	public static void main(String[] args) 
	{
		VectorTextFile A = new VectorTextFile("dracula.txt");
		VectorTextFile B = new VectorTextFile("lewis.txt");

		double theta = VectorTextFile.Angle(A,B);

		System.out.println("The angle between A and B is: " + theta + "\n");
	}
}
