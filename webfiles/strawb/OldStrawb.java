import java.awt.Graphics;
import java.awt.*;
import java.applet.*;
import java.lang.Math.*;
import java.applet.Applet;
import java.util.Random;



public class Strawb extends Applet
{
  int kmax = 4;
  int[] radius = new int[6];
  int[] npoints = new int[6];
  int[] nbase = new int[6];
  int iptr, iptr2;
  double[] length = new double[6];
  double[] x = new double[200];
  double[] y = new double[200];
  double[] ang = new double[200];
  double[] pival = new double[6];
  double[] rhoval = new double[6];
  boolean[] omit = new boolean[200];
//  Color bgnd;

  public void init() 
  {
    Color bgnd = new Color(159,172,159);
    setBackground(bgnd); // change here the applet window color


    /* --------------------
       Set parameter values 
       -------------------- */
    pival[1] = 1.0;
    pival[2] = 0.9;
    pival[3] = 0.6;
    pival[4] = 0.4;
    pival[5] = 0.15;
    rhoval[1] = 0.0;
    rhoval[2] = 0.0;
    rhoval[3] = 0.1;
    rhoval[4] = -0.2;
    rhoval[5] = 0.0;
  
    /* ------------------------------------
       theta is branching angle in radians
       len is length of next branch as a 
       proportion of length previous branch
       ------------------------------------ */
    double theta = 0.017453292 * 47.5;
    double len = 0.55;

    /* ----------------------------
       Initialise various variables 
       ---------------------------- */
    npoints[0] = 1;
    npoints[1] = 3;
    nbase[0] = 1;
    nbase[1] = 2;
    length[0] = 1.0;
    length[1] = len;
    radius[0] = 16;
    radius[1] = 12;
    for (int k=2; k<=kmax; k++) {
       npoints[k] = 2 * npoints[k-1];
       nbase[k] = 2 * nbase[k-1];
       length[k] = len * length[k-1];
       radius[k] = radius[k-1] - 2;
    }
    omit[0] = false;

    /* --------------------------------
       Set up co-ordinates for plotting
       -------------------------------- */
    x[1] = 0.0; y[1] = 0.0; x[2] = 0.0; y[2] = 1.0;
    x[3] = 0.0; y[3] = 0.5;
    ang[4] = 1.5708-theta; ang[5] = 1.5708+theta;
    x[4] = x[3] + length[1] * java.lang.Math.cos(ang[4]);
    y[4] = y[3] + length[1] * java.lang.Math.sin(ang[4]);
    x[5] = x[3] + length[1] * java.lang.Math.cos(ang[5]);
    y[5] = y[3] + length[1] * java.lang.Math.sin(ang[5]);
    for (int k=2; k<=kmax; k++) {
       iptr = npoints[k] -3;
       for (int j=1; j<nbase[k]/2; j++) {
          iptr = iptr + 3;
          iptr2 = iptr / 2;
          x[iptr] = 0.5 * (x[iptr2] + x[iptr2+1]);
          y[iptr] = 0.5 * (y[iptr2] + y[iptr2+1]);
          ang[iptr+1] = ang[iptr2+1] - theta;
          ang[iptr+2] = ang[iptr2+1] + theta; 
          x[iptr+1] = x[iptr] + length[k] * java.lang.Math.cos(ang[iptr+1]);
          y[iptr+1] = y[iptr] + length[k] * java.lang.Math.sin(ang[iptr+1]);
          x[iptr+2] = x[iptr] + length[k] * java.lang.Math.cos(ang[iptr+2]);
          y[iptr+2] = y[iptr] + length[k] * java.lang.Math.sin(ang[iptr+2]);
          iptr = iptr + 3;            
          x[iptr] = 0.5 * (x[iptr2] + x[iptr2+2]);
          y[iptr] = 0.5 * (y[iptr2] + y[iptr2+2]);
          ang[iptr+1] = ang[iptr2+2] - theta;
          ang[iptr+2] = ang[iptr2+2] + theta; 
          x[iptr+1] = x[iptr] + length[k] * java.lang.Math.cos(ang[iptr+1]);
          y[iptr+1] = y[iptr] + length[k] * java.lang.Math.sin(ang[iptr+1]);
          x[iptr+2] = x[iptr] + length[k] * java.lang.Math.cos(ang[iptr+2]);
          y[iptr+2] = y[iptr] + length[k] * java.lang.Math.sin(ang[iptr+2]);
       }
    }
  }

  public void paint(Graphics g)
  {

  while(true)
  {
     // Set background	
    Color bgnd = new Color(159,172,159);
    Color stalk = new Color(0,100,0);

    int chk3, chk32, xstart, xend, ystart, yend, jj, np;
    double frac, frac1, bnd1, bnd2, bnd3, urand;
    for (int k=0; k<=kmax; k++) {
       np = nbase[k];
       if (k > 0) {
          np = np / 2;}

       bnd1 = (1-pival[k])*(1-pival[k]) + rhoval[k] * pival[k]*(1-pival[k]);
       bnd2 = bnd1 + (1-rhoval[k]) * pival[k]*(1-pival[k]);
       bnd3 = bnd2 + (1-rhoval[k]) * pival[k]*(1-pival[k]);

       for (int j=1; j<=np; j++) {
          jj = npoints[k] + 3*(j-1);
          if (j > 1)
          {
               // First check if this is omitted already
             chk3 = (jj+1) / 3;
             chk32 = chk3 + chk3/2 + 1;
             if (omit[chk32])
             {
                omit[jj+1] = true;
                omit[jj+2] = true;
             }
               // If not, decide whether to omit stochastically
            else
             {
                urand = java.lang.Math.random();
                if (urand < bnd1)
                {
                   omit[jj+1] = true;
                   omit[jj+2] = true;
                }
                  else if(urand < bnd2)
                  {
                   omit[jj+1] = true;
                   omit[jj+2] = false;
                  }
                  else if(urand < bnd3)
                  {
                   omit[jj+1] = false;
                   omit[jj+2] = true;
                  }
              } 
           } 
        }

        /* -----------------------------------
           Draw the lines, with suitable delay
           ----------------------------------- */
//        int i200 = 175, i300 = 250;
        int iscale = 200, ixoff=155, iyoff=210;
      
        for (int ii=0; ii<=50; ii++) {
           frac = ii / 50.0;
           frac1 = 1.0 - frac;
           for (int j=1; j<=np; j++) {
              jj = npoints[k] + 3*(j-1);
              xstart = (int)(iscale * x[jj]+ixoff);
              ystart = (int)(iyoff-iscale * y[jj]);
              xend = (int)(iscale * (frac1*x[jj]+frac*x[jj+1])+ixoff);
              yend = (int)(iyoff-iscale * (frac1*y[jj]+frac*y[jj+1]));
              if (omit[jj+1])
                 g.setColor(bgnd);
                else                   
                 g.setColor(stalk);
              g.drawLine(xstart, ystart, xend, yend);
              xend = (int)(iscale * (frac1*x[jj]+frac*x[jj+2])+ixoff);
              yend = (int)(iyoff-iscale * (frac1*y[jj]+frac*y[jj+2]));
              if (omit[jj+2])
                 g.setColor(bgnd);
                else                   
                 g.setColor(stalk);
              g.drawLine(xstart, ystart, xend, yend);
              for (int delay=0; delay < 2000000; delay++);
           }
        }

        /* ------------------------------------------
           Draw the strawberries, with suitable delay
           ------------------------------------------ */
        g.setColor(Color.red);
        for (int j=1; j<=np; j++) {
            jj = npoints[k] + 3*(j-1);
            xend = (int)(iscale * x[jj+1]+ixoff);
            yend = (int)(iyoff-iscale * y[jj+1]);
                if (omit[jj+1])
                   g.setColor(bgnd);
                  else                   
                   g.setColor(Color.red);
            g.fillOval(xend-radius[k]/2,yend-radius[k]/2,radius[k],radius[k]);
            if (k > 0) {
               xend = (int)(iscale * x[jj+2]+ixoff);
               yend = (int)(iyoff-iscale * y[jj+2]);
                if (omit[jj+2])
                   g.setColor(bgnd);
                  else                   
                   g.setColor(Color.red);
               g.fillOval(xend-radius[k]/2,yend-radius[k]/2,radius[k],radius[k]);
            }
        }
        for (int delay=0; delay < 50000000; delay++);
    }
        for (int delay=0; delay < 500000000; delay++);

    }
  }
}
