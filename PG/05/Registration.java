package cz.upol.pg;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import java.awt.image.DataBufferByte;
import java.awt.image.WritableRaster;
import java.util.Arrays;

public class Registration {

  public static void registrationFun(String pic1, String pic2) {
    int pixelvalue;
    int[] leftTopIm1 = new int[2];
    int[] bottomRightIm1 = new int[2];
    int[] leftTopIm2 = new int[2];
    int[] bottomRightIm2 = new int[2];
    boolean first = true;
    BufferedImage img1 = null;
    BufferedImage img2 = null;

    try {
      img1 = ImageIO.read(new File(pic1));
    } catch (IOException e) { }

    try {
      img2 = ImageIO.read(new File(pic2));
    } catch (IOException e) { }

    WritableRaster wr1 = img1.getRaster() ;
    for (int y=0 ; y < img1.getHeight() ; y++)
      for (int x=0 ; x < img1.getWidth() ; x++) {
        pixelvalue = wr1.getSample(x, y, 0);
        if (pixelvalue == 0 && first) {
          leftTopIm1[0] = x + 1;
          leftTopIm1[1] = y + 1;
          first = false;
        }
        if (pixelvalue == 0) {
          bottomRightIm1[0] = x + 1;
          bottomRightIm1[1] = y + 1;
        }
      }

    first = true;

    WritableRaster wr2 = img2.getRaster() ;
    for (int y=0 ; y < img2.getHeight() ; y++)
      for (int x=0 ; x < img2.getWidth() ; x++) {
        pixelvalue = wr2.getSample(x, y, 0);
        if (pixelvalue == 0 && first) {
          leftTopIm2[0] = x + 1;
          leftTopIm2[1] = y + 1;
          first = false;
        }
        if (pixelvalue == 0) {
          bottomRightIm2[0] = x + 1;
          bottomRightIm2[1] = y + 1;
        }
      }

    int moveX = leftTopIm2[0] - leftTopIm1[0];
    int moveY = leftTopIm2[1] - leftTopIm1[1];
    double expansionX = (bottomRightIm2[0] - bottomRightIm2[0]) / (leftTopIm1[0] + leftTopIm1[0]);
    double expansionY = (bottomRightIm2[1] - bottomRightIm2[1]) / (leftTopIm1[1] + leftTopIm1[1]);

    System.out.println("Posunuti: " + "[" + moveX + ", " + moveY + "]");
    System.out.println("Zvetseni x: " + expansionX);
    System.out.println("Zvetseni y: " + expansionY);
  }
  public static void main(String[] args) throws IOException {
    Registration.registrationFun("obdelnik1.png", "obdelnik2.png");    
  }
}
