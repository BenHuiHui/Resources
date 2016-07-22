package sg.edu.nus.cs2020;

public class DocumentDistanceMain 
{

	public static void main(String[] args) 
	{
		// since the relative directory is not the folder of this class, 
		// 		I used absolute directory
		VectorTextFile Shakesphere = new VectorTextFile("D:\\syy\\hamlet.txt");
		VectorTextFile Kafka = new VectorTextFile("D:\\syy\\metamorphosis.txt");
		VectorTextFile mystery = new VectorTextFile("D:\\syy\\mystery.txt");
		
		double Shake_mystery = VectorTextFile.Angle(Shakesphere,mystery);
		double Kafka_mystery = VectorTextFile.Angle(Kafka, mystery);

		System.out.println("The angle between Shake_mystery" +
				" and mystery is: " + Shake_mystery + "\n");
		System.out.println("The angle between Kafka" +
				" and mystery is: " + Kafka_mystery + "\n");
		System.out.println("Thus, the work is belongs to " + ((Shake_mystery > Kafka_mystery)?"Kafka":"Shakesphere"));
	}
}
