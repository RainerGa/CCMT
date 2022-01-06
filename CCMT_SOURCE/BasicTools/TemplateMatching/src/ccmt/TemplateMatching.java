package ccmt;

import org.opencv.core.Core;
import org.opencv.core.Core.MinMaxLocResult;
import org.opencv.core.Mat;
import org.opencv.core.Point;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

public class TemplateMatching {

	public static void main(String[] args) {

		// Arguments
		if (args.length != 2) {
			System.out.println("Parameters:");
			System.out.println("java -jar TemplateMatching.jar [Sourcefile] [search for Picture]");
			System.out.println(
					"Example: java -jar TemplateMatching.jar c:\\temp\\screenshot.png c:\\temp\\searchPicture.png");
			System.out.println("Returns: X Coordinate, Y Coordinate");
			System.out.println("Example: 123, 674");

			// Exitcode see:
			// https://shapeshed.com/unix-exit-codes/#what-exit-code-should-i-use
			System.exit(128);
		}

		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		Mat source = null;
		Mat template = null;

		// For Testing purpose
		/*
		 * String filePath=
		 * "C:\\Users\\Spielen\\eclipse-workspace\\CCMT_TemplateMatching\\testdata\\";
		 * source=Imgcodecs.imread(filePath+"full_screenshot.png");
		 * template=Imgcodecs.imread(filePath+"search_for_screenshot.png");
		 */

		source = Imgcodecs.imread(args[0]);
		template = Imgcodecs.imread(args[1]);

		Mat outputImage = new Mat();
		int machMethod = Imgproc.TM_CCOEFF;
		// Template matching method
		Imgproc.matchTemplate(source, template, outputImage, machMethod);

		MinMaxLocResult mmr = Core.minMaxLoc(outputImage);
		Point matchLoc = mmr.maxLoc;

		// For Testing purpose
		// Draw rectangle on result image
//		Imgproc.rectangle(source, matchLoc, new Point(matchLoc.x + template.cols(), matchLoc.y + template.rows()),
//				new Scalar(0, 255, 255));
//
//		
//		Imgcodecs.imwrite(filePath + "sonuc.jpg", source);
//		System.out.println("Complated.");
//
//		System.out.println("X: "+ matchLoc.x);
//		System.out.println("Y: "+ matchLoc.y);
//
//		System.out.println("X: "+ (matchLoc.x + template.size().width));
//		System.out.println("Y: "+ (matchLoc.y + template.size().height));

		System.out.println("Click X: " + (matchLoc.x + template.size().height / 2) + ", Click Y:"
				+ (matchLoc.y + template.size().width / 2));

	}

}