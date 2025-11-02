import java.applet.*;
// this library enables an applet to be run
import java.awt.*;
// this library enables the use of the 'paint' method, which is where all 
// the graphics are drawn.
import java.util.Random;
// this library enables the Random number generator to be used.
import java.awt.event.*;
// this library allows the use of the 'action performed' method, which is 
// used when detecting anything entered or pressed by the user.
import javax.swing.*;
// this allows the use of buttons.



public class FungiSim extends Applet implements Runnable, ActionListener
{
   Font header = new Font("Helvetica",Font.BOLD,20);
   // sets up a new type and size of font which can now be called upon later 
   // in the program using the name 'header'.
   Font labels = new Font("Arial",0, 12);
   // sets up a new type and size of font which can now be called upon later 
   // in the program using the name 'arial'.
   Color title = new Color(0, 0, 0);
   // sets up a new Colour for the title font, with the RGB values of (0,0,0),
   // which can now be called upon later in the program using the name 'title'.
   Color petri = new Color(192, 192, 192);
   // sets up a new Colour for the colour of the petridish, with the RGB values
   // of (192, 192, 192), which can now be called upon later in the program 
   // using the name 'petri'.
   Color inhibitory = new Color(255, 0, 0);
   // sets up a new Colour for the inhibitory spores, with the RGB values of 
   // (255, 0, 0), which can now be called upon later in the program using 
   // the name 'petri'.
   Color White = new Color(250,250,250);
   // sets up a new Color, with the RGB values of (250, 250, 250), which can
   // now be called upon later in the program using the name 'White'.
   int dishx = 155;
   // this creates an integer variable called dishx, which is used as the 
   // starting x co-ordinate of the petridish and assigns it with an original 
   // value of 155.
   int dishy = 195;
   // this creates an integer variable called dishy, which is used as the 
   // starting y co-ordinate of the petridish and assigns it with an original 
   // value of 195.
   int dishradius = 145;  
   // this creates an integer variable called dishradius and assigns it with
   // an original value of 145. This is used as the radius of the petridish
   int radiusA = 2;
   // this creates an integer variable called radiusA, and assigns it with an original 
   // value of 2. This radius is used as the original radius of the spores drawn onto 
   // the screen.
   int radiusB = 2; 
   // this creates an integer variable called radiusB, and assigns it with an original
   // value of 2. This radius is used as the original 
   // radius of the spores drawn onto the screen.
   int maxnumofspores = 100;
   // This sets up an integer variable which is used to denote the maximum number of
   // each type of spore which can be entered by the user. It is assigned with an 
   // original value of 100.
   int[] x_a = new int[maxnumofspores + 1];
   // This sets up an array of integers for the x co-ordinates of the type A spores. 
   // The array size (the amount which the array can store) is maxnumofspores + 1.
   int[] y_a = new int[maxnumofspores + 1];
   // This sets up an array of integers for the y co-ordinates of the type A spores. 
   // The array size (the amount which the array can store) is maxnumofspores + 1.
   int[] x_b = new int[maxnumofspores + 1];
   // This sets up an array of integers for the x co-ordinates of the type B spores.
   // The array size (the amount which the array can store) is maxnumofspores + 1.
   int[] y_b = new int[maxnumofspores + 1];
   // This sets up an array of integers for the y co-ordinates of the type B spores.
   // The array size (the amount which the array can store) is maxnumofspores + 1.
   int numofAspores, numofAdrawn, numofBdrawn, numofAgrown; 
   // These variables are all related to their respective spores (type A and type B).
   // The number of A spores is the number entered by the user, the numofAdrawn and 
   // numofBdrawn are used to represent how many spores have currently been grown. 
   // The numofAgrown stores the number of spores that grow each time a simulation 
   // takes place.
   int numofBspores = 50;
   // This sets up a variable to store the number of B spores, as entered by the user, 
   // and it is assigned an original value of 50.
   int inhiblength, r;
   // The inhibitionlength variable stores the value of the inhibition distance, and the
   // variable r is set up to be the generally radius of one of the spores.
   int lineleft, lineright;
   // This sets up two variables, which will be used later on to represent the starting
   // and finishing points of the inhibition line.
   int linecentre = 464;
   // This is used as the central point of the inhibition line.
   int linelength = 5; 
   // Sets up a variables called linelength, which later on becomes the inhibition 
   // distance. It is given the original value of 5 units.
   boolean[] inhib = new boolean[maxnumofspores + 1];
   // This creates a new boolean array. This array will hold a value of true of force
   // for each of the type A spores. The array size is the maximum number of spores + 1,
   // which means it can hold up to this amount of pieces of data.
   Button lessButton, moreButton, helpButton, runButton;
   // This declares all the buttons, originally setting them up before they are added
   // to the screen later on in the program.
   boolean helpon = false;
   // This sets up a boolean called helpon, which is originally set to be false, but
   // will change if the 'help' button is pressed. There is then certain bits of code
   // which only run when helpon is true.
   boolean runon = false;
   // This sets up a boolean called runon, which is originally set to be false, but 
   // will change if the 'run' button is pressed. There is then certain bits of code 
   // which only run when runon is true.
   TextField target, inhibit;
   // This declares all the textfields, so they are now present to be used later on 
   // in the program.

   private JFrame frame;
   // This is the original of the error message frame which will appear later on in 
   // the code.
   private Image dbImage;
   // This is the buffer to store the double buffered image, until it is dumped onto 
   // the screen.
   private Graphics dbg;
   // This is the graphics image that is stored for double buffering
 

  //================================================================================
   public void init ()
  // this starts the 'init' method, which is used to initialised all the buttons and 
  // textfields which are originally drawn onto the screen.
  //================================================================================
   {

      setBackground (Color.cyan);
      // this sets the background colour of the screen to be cyan.
      setLayout(null);
      // this sets the layout to null, which means that a co-ordinate system is used
      // to position things onto the screen.
      lessButton = new Button("Less");
      // this originally sets up a the 'lessButton', and the "Less" inside the brackets
      // is the label which will go on the button.
      moreButton = new Button("More");
      // this originally sets up a the 'moreButton', and the "More" inside the brackets
      // is the label which will go on the button.
      helpButton = new Button("Help");
      // this originally sets up a the 'helpButton', and the "Help" inside the brackets 
      // is the label which will go on the button.
      runButton = new Button("Run");
      // this originally sets up a the 'runButton', and the "Run" inside the brackets
      // is the label which will go on the button.
      
            //** There is a co-ordinate system used in the brackets below. The first 
            // two integers are the starting x and y co-ordinates respectively, and the 
            // second two integers are the length of the button in the x and y direction
            // respectively.
      
      lessButton.setBounds(350,210,70,30);
      // Sets the bounds of the 'less' button.
      moreButton.setBounds(510,210,70,30);
      // Sets the bounds of the 'more' button.
      helpButton.setBounds(120,350,70,30);
      // Sets the bounds of the 'help' button.
      runButton.setBounds(430,270,70,30);
      // Sets the bounds of the 'run' button.
      
            //** The following code adds the buttons to the actionlistener, which means
            // that any button presses can be detected.
      
      lessButton.addActionListener(this);
      // Adds the 'less' button to the action listener.
      moreButton.addActionListener(this);
      // Adds the 'more' button to the action listener.
      helpButton.addActionListener(this);
      // Adds the 'help' button to the action listener.
      runButton.addActionListener(this);
      // Adds the 'run' button to the action listener.
      
            //** The following code simply adds the buttons onto the screen, in their 
           // correct positions.
      
      add(lessButton);
      // adds the 'less' button to the screen.
      add(moreButton);
      // adds the 'more' button to the screen.
      add(helpButton);
      // adds the 'help' button to the screen.
      add(runButton); 
      // adds the 'run' button to the screen.

      target = new TextField ("50");
      // sets up a new Text field for the target spores, the "50" inside the brackets 
      // puts an original value of 50 into the textbox. 
      inhibit = new TextField ("50");
      // sets up a new Text field for the inhibitory spores, the "50" inside the 
      // brackets puts an original value of 50 into the textbox. 
      inhibit.addActionListener(this);
      // adds the inhibit textfield to the action listener, so anything entered can 
      // be picked up by the program.
      target.addActionListener(this);
      // adds the target textfield to the action listener, so anything entered can 
      // be picked up by the program.
      
            //** There is a co-ordinate system used in the brackets below. The first 
            // two integers are the starting x and y co-ordinates respectively, and 
            // the second two integers are the length of the button in the x and y 
            // direction respectively.
      
      inhibit.setBounds(440,152,50,20);
      // sets the boundaries of the inhibit textfield.
      target.setBounds(440,80,50,20);
      // sets the boundaries of the target textfield.
      
            //** The following code simply adds the buttons onto the screen, in their 
            // correct positions.
            
      add (target);
      // adds the target textfield to the screen.
      add (inhibit);
      // adds the inhibit textfield to the screen.
 
      Label inhibit1 = new Label ("Number of inhibitory spores:");
      // This originally sets up the inhibit1 label, and the text inside the brackets
      // is what is to be drawn as the label
      Label target1 = new Label ("Number of target spores:");
      // This originally sets up the target1 label, and the text inside the brackets
      // is what is to be drawn as the label
                  
            //** There is a co-ordinate system used in the brackets below. The first
            // two integers are the starting x and y co-ordinates respectively, and 
            // the second two integers are the length of the button in the x and y 
            // direction respectively.
      
      target1.setBounds(390,52,160,20);
      // This sets the boundaries of the target1 label.
      inhibit1.setBounds(390,125,160,20);
      // This sets the boundaries of the inhibit1 label.
      inhibit1.setFont (labels);
      // This sets the font of the inhibit1 label to the font variable called lables, 
      // which has been declared earlier in the program.
      target1.setFont (labels);      
      // This sets the font of the target1 label to the font variable called lables,
      // which has been declared earlier in the program.
      add (inhibit1);
      // This adds the inhibit1 label onto the screen.
      add (target1);
      // This adds the target1 label onto the screen.
   }
      
        
 //===================
   public void start()
   // This is the 'start' method, which is simply used to initialise the thread.
 //===================
   {
      Thread th = new Thread (this);
      // This defines a new thread.
      th.start();
      // This starts the thread.
   }
 
 //==================================================================================
   public void run()
   // This is the 'run' method, which is used to do all the calculations, such as 
   // generating random co-ordinates and testing to see whether a spore is inhibited 
   // or not.
 //==================================================================================
{
      Random number = new Random(); 
      // This sets up a new random number function, called number. This now enables
      // us to generate a random number later on in the code.
      int lengtha_x, lengtha_y, a_xtry, a_ytry;
      // This variables are realted to the random numbers being generated for the type A
      // spores. The a_xtry and a_ytry will store the random x and y co-ordinates 
      // generated, which will be tested to make sure they are not too close to the edge
      // of the circle. Lengtha_x and lengtha_y are used to store the length in the 
      // horizontal and vertical directions that the co-ordinates are away from the 
      // centre point of the circle.
      
      int lengthb_x, lengthb_y, b_xtry, b_ytry;
      // The variables declared here have the same function as the variables above,
      // except they are for the type B spores.
      int lengthab_x, lengthab_y;
      // This line is the declarations of two variables, which will be the distance
      // between a type A and a type B spore, in the x and y directions.
      numofBspores = 50;
      // This enters the value of 50 into the numofBspores variable.
      numofAspores = 50;
      // This enters the value of 50 into the numofAspores variable.
      inhiblength = linelength;
      // This makes the inhibitory length equal to the linelength, which is the
      // length of the line adjusted by the user.

      Thread.currentThread().setPriority(Thread.MIN_PRIORITY);
      // This line of code sets the current thread to have minimum priority, 
      // meaning that anything else the computer wishes to do takes preference.

      while (true)
      // This simply means that the loop will executed indefinitely, until the 
      // program is closed down. 
      {

      while(!runon)
      {
      }
      // The above codes means the nothing will happen while the runon boolean is
      // set to false (ie before the 'run' button is pressed).
      
      numofAdrawn = 0;
      // this sets the numofAdrawn variable to 0, as originally none of them are
      // drawn onto the screen.
      numofBdrawn = 0;
      // this sets the numofBdrawn variable to 0, as originally none of them are
      // drawn onto the screen.
      numofAgrown = 0;
      // this sets the numofAgrown variable to 0, as originally none of them have 
      // grown.

      while (numofAdrawn < numofAspores)
      // This initialises a while loop, which will only run while the numofAdrawn
      // variable is less than the numofAspores, ie the number that have been drawn 
      // so far is less than the amount which need to be drawn, as entered by the 
      // user. This while function is used to generate the random co-ordinates for
      // the type A spores.
      {
 
         a_xtry = number.nextInt(291) + 10;
         // This generates an x co-ordinate to be tested, between 1 and 301. This is
         // because the Petri dish's end co-ordinate is 301 in the x - direction, 
         // therefore this will ensure that it is within the circle.
         a_ytry = number.nextInt(291) + 50;
         // This generates a y co-ordinate to be tested, between 1 and 341. This is 
         // because the Petri dish's end co-ordinate is 341 in the y - direction, 
         // therefore this will ensure that it is within the circle.

         lengtha_x = dishx - a_xtry;
         // This makes the variable length a_x equal to the central x co-ordinate of the
         // dish - the x co-ordinate which is being tested.
         lengtha_y = dishy - a_ytry;
         // This makes the variable length a_y equal to the central y co-ordinate of the
         // dish - the y co-ordinate which is being tested.

         if (Math.pow(lengtha_x,2) + Math.pow(lengtha_y,2) < 0.90* Math.pow(dishradius,2))
         // This if function is a use of pythagoras' theorem, to test whether the co-ordinate
         // is within 90% of the circle. If this is not the case then the random point 
         // generated will be rejected, and the code below will not run.
         {  
            numofAdrawn = numofAdrawn + 1;
            // this adds one to the numofAdrawn variable, so that once a set of acceptable
            // co-ordinates have been found, it is ready to be drawn onto the screen, so 
            // the number drawn can go up.
            x_a[numofAdrawn] = a_xtry;
            // The numofAdrawn is taken, and the variable a_xtry is passed into the array
            // for the x co-ordinates of the type A spores, in the position which matches
            // the numofAdrawn variable.
            y_a[numofAdrawn] = a_ytry;
            // The numofAdrawn is taken, and the variable ytry is passed into the array 
            // for the y co-ordinates of the type A spores, in the position which matches 
            // the numofAdrawn variable.
         } 
      }
   

      while (numofBdrawn < numofBspores)
      // this while function is used for generating random co-ordinates for the type B
      // spores. The code below is only executed while the number of B spores drawn is
      // less than the number of B spores, which is the number the user requested to 
      // be drawn.
      {
 
         b_xtry = number.nextInt(291) + 10;
         // This generates an x co-ordinate to be tested, between 1 and 301. This is 
         // because the Petri dish's end co-ordinate is 301 in the x - direction, 
         // therefore this will ensure that it is within the circle.
         b_ytry = number.nextInt(291) + 50; 
         // This generates a y co-ordinate to be tested, between 1 and 341. This is because
         // the Petri dish's end co-ordinate is 341 in the y - direction, therefore this 
         // will ensure that it is within the circle.
         
         lengthb_x = dishx - b_xtry;
         // this changes the value of lengtha, the calculation dishx - atry is done, and the
         // outcome is stored in the lengtha variable.
         lengthb_y = dishy - b_ytry;
         // this changes the value of lengthb, the calculation dishy - btry is done, and the 
         // outcome is stored in the lengtha variable.

         if (Math.pow(lengthb_x,2) + Math.pow(lengthb_y,2) < 0.90* Math.pow(dishradius,2))
         // This if function is a use of pythagoras' theorem, to test whether the co-ordinate 
         // is within 90% of the circle. If this is not the case then the random point generated 
         // will be rejected, and the code below will not run.
         {  
            numofBdrawn = numofBdrawn + 1;
            // this adds one to the numofBdrawn variable, so that once a set of acceptable 
            // co-ordinates have been found, it is ready to be drawn onto the screen, so 
            // the number drawn can go up.
            x_b[numofBdrawn] = b_xtry;
            // The numofBdrawn is taken, and the variable atry is passed into the array 
            // for the x co-ordinates of the type B spores, in the position which matches
            // the numofAdrawn variable.
            y_b[numofBdrawn] = b_ytry;
            // The numofBdrawn is taken, and the variable btry is passed into the array 
            // for the y co-ordinates of the type B spores, in the position which matches
            // the numofAdrawn variable.
         }
      } 
         for (int i = 1; i <= numofAdrawn; i++)
         // A counter is set up here, and it will increase every time the loop is done. 
         // It will only proceed to do the code within the loop if the counter is less 
         // than the numofAdrawn variable, which is the number there are on the screen 
         // before any growth has taken place.
         {
            inhib[i] = false;
            // The inhib boolean is originally set to false.
            for (int j = 1; j <= numofBdrawn; j++)
            // A counter is set up here, and it will increase every time the loop is done. 
            // It will only proceed to do the code within the loop if the counter is less 
            // than the numofBdrawn variable, which is the number of type B spores there 
            // are on the screen before any growth has taken place.
            {
            lengthab_x = x_b[j] - x_a[i];
            // This calculates the length that every type A spore is away from every type B 
            // spore in the x-direction.
            lengthab_y = y_b[j] - y_a[i];
            // This calculates the length that every type A spore is away from every type B 
            // spore in the y-direction.
            if (Math.pow(lengthab_x,2) + Math.pow(lengthab_y,2) < Math.pow(inhiblength,2))
            // This test makes use of pythagoras' theorem, to test whether the distance 
            // between a type A spore and a type B spores is less than the inhibition length.
               inhib[i] = true;
            // If this is the case then the appropriate spore, who's number is the 
            // count of i, will be stored as true in the inhib boolean.
            }
            if (!inhib[i])
            // This if statement means that the code below will only occur if 
            // the spore is not inhibiited.
               numofAgrown = numofAgrown + 1;
            // Since the spore is not inhibited, it will grow, and therefore 1 
            // more is added to the tally of the number of A grown.
         }
         
         r = radiusA; 
         // The variable r is initially set to the original spore radius.

         for (int p = 1; p <= 6; p++)
         // This is a for loop which will run 6 times, until the counter p which is 
         // passed in reaches 6. It is increased every time the loop runs.
         {   
            repaint();
            // The screen is then repainted with the radius of the A spores at the 
            // current value of r.
            r = r + 1;
            // The radius is then incremented. 
            
            try
            {
               Thread.sleep(250);
            }
            // This sleep function means the system will pause for 0.25 milliseconds 
            // (0.25 seconds).
            catch (InterruptedException ex)
            {
            }
            // This exception catcher has to be included when using the sleep method. 
            // It is called if something tries to interrupt the pause. But in this case 
            // no action is taken, so attempts to interrupt the pause are ignored.
         }
            Thread.currentThread().setPriority(Thread.MAX_PRIORITY);
            // The thread now becomes maximum priority, which means nothing else 
            // can be done until the animation is finished.
            runon = false;
            // This switches the runon boolean off, as the running of the 
            // simulation has now been completed.
            }  
   }
  
  //==============================================================================
   public void update (Graphics page)
   // This is the 'update' method. Within this method is the code for the double 
   // buffering, which makes the animation run smoother, as it prepares the screen 
   // to be drawn in a 'dummy' area, before dumping it all on the actual screen at 
   // once when it is refreshed, rather than doing it bit by bit
  //==============================================================================
   {
      if (dbImage == null)
      {
         dbImage = createImage (this.getSize().width, this.getSize().height);
         // Create a new buffer (image) if none exists 
         dbg = dbImage.getGraphics ();
         // Create a new graphics object that can be used to draw to the buffer 
         // image instead of the screen. 
      }
      
      dbg.setColor (getBackground ());
      dbg.fillRect (0, 0, this.getSize().width, this.getSize().height);
      // These two lines overwrite the graphics image with a blank rectangle with the 
      // background colour
      
      dbg.setColor (getForeground());
      paint (dbg);
      // Reset the foreground colour and paint the image into the buffer
      
      page.drawImage (dbImage, 0, 0, this);
      // Dump the contents of the buffer to the screen
   }
    

  //=================================================================================
   public void paint (Graphics page)
   // This is the 'paint' method in which all the graphics are drawn onto the screen, 
   // and the code for redrawing the spores each time they grow is contained.
  //=================================================================================
   { 
      
      int radius;
      // This sets up local variable, which is used to store the current radius of 
      // each spore in turn.
      
      page.setColor(petri);
      // The colour is set to the variable 'petri', which has been declared gloablly 
      // along with it's RGB value.
      page.fillOval (dishx - dishradius, dishy - dishradius , dishradius*2, dishradius*2);
      // This drawn an oval onto the screen, which is filled with the current colour, 
      // 'petri'. The dishx - dishradius represents the x co-ordinate starting point, the 
      // dishy - dishradius represents the y co-ordinate starting point, the dishradius*2 
      // represents the diameter of the circle, and the length in the x and y direction 
      // which the circle is to be drawn out.
      page.setFont(header);
      // This sets the font to 'header' which is a variable that has been declared 
      // globally.
      page.setColor(title);
      // This sets the colour to 'title', which is a variable that has been declared 
      // globally. 
      page.drawString ("Fungal colonies with inhibition", 170, 30);
      // The 'drawString' function is used to draw a sentence of text onto the screen. 
      // The text inside the quotation marks is what is to be written, and the two values 
      // after it are the starting x and y co-ordinates.
      page.setColor(inhibitory);
      // This sets the colour to 'inhibitory', which is a variable that has been declared 
      // globally.

      for (int i = 1; i <= numofBspores; i++)
         page.fillOval (x_b[i] - radiusB, y_b[i] - radiusB , radiusB*2, radiusB*2);
         // This draws all of the inhibitory spores onto the screen, using the 
         // co-ordinates stored in the array.
 
      page.setColor (Color.black);
      // This sets the current colour to black, which is used for the target spores. Any 
      // subsequent items drawn on the screen will now appear black, until the colour is 
      // altered. 

      for (int p = 1; p <= 6; p++)
      // This is a for loop, with the parameter 'p' passed into it. 'p' is originally 
      // set to 1, and the p++ means it increases, but only until p = 6, because of the 
      // p<=6 aspect. This means that the code below will only run 6 times, meaning the 
      // growing spores will grow to 5 times as big.
      {   
         for (int i = 1; i <= numofAdrawn; i++)
         // This is another for loop. The integer value 'i' is passed into this loop, 
         // and the 'i++' means it will keep increasing, but only until 'i' reaches the 
         // number of A spores drawn. The 'i' is used as an array reference, thus making
         // sure that all the values in the array are acounted for, as there will never
         // be any more array elements than the numofAdrawn variable.
         {
            if (inhib[i])
            // If the spore is inhibited, then the radius remains at the intiial spore
            // radius, radiusA.
            {
               radius = radiusA;
            }
            else
            // Otherwise, if a spore is not inhibited, then the radius is given the 
            // value of r, which increases every 2 seconds.
            {
               radius = r;
            }
         page.fillOval (x_a[i] - radius, y_a[i] - radius , radius*2, radius*2); 
         // This redraws all the typeA spores wth the appropriate size.
         }

      }

      lineleft = linecentre - linelength/2;
      // This calculates the co-ordinate of the left hand end of the inhibition line. It is
      // calculated by taking the central point and subtracting half of the length of the 
      // line from it.
      lineright = linecentre + linelength/2;
      // This calculates the co-ordinate of the right hand end of the inhibition line. 
      // It is calculated by taking the central point and adding half of the length of 
      // the line from it.
      page.drawLine(lineleft,230,lineright,230);
      // this draws the line onto the screen, the value in the lineleft variable and 230 
      // are the original x and y co-ordinates respectively and the value in lineright 
      // and 230 are the final x and y co-ordinates.
      
      double percentofAgrown;
      // This sets up a local variable, percentofAgrown, which is a double, meaning it may 
      // contain decimal places.
      percentofAgrown = (numofAgrown/(numofAspores + 0.0))*100;
      // This is a calculation for the percentofAgrown variable, which is done by dividing
      // the numofAgrown by the numofAspores and multiplying by 100.
      page.setFont(labels); 
      // This sets the font to 'labels' which has been declared globally.
      page.drawString ("The number of colonies that grew was: " ,350, 350);
      // The 'drawString' function is used to draw a sentence of text onto the screen. 
      // The text inside the quotation marks is what is to be written, and the two values 
      // after it are the starting x and y co-ordinates.
      page.setColor(Color.blue);
      // This sets the current colour to blue, so that anything to be subsequently added 
      // will be blue.
      page.setFont(header);
      // This sets the font to 'header' which has been declared globally.
      page.drawString (numofAgrown + " (" + Math.round(percentofAgrown) + "%)",405, 380);
      // This writes the value in the numofAgrown variable onto the screen, and then there
      // are brackets added to the screen, inside which the value of the percentofAgrown 
      // variable is added. The Math.round function is used to round the number given to 
      // the nearest whole number. The values after are the co-ordinates of the start of 
      // the text to be written
         
      if (helpon)
      // This sets up an if statement, which will only run if the helpon boolean is 
      // turned on.
      {
            page.setColor (Color.blue);
            // This sets the current colour to blue.
            page.setFont(labels);
            // This sets the font to the font gloabally declared as help.
            page.drawString("Please enter integer values into", 190, 390);
            page.drawString("the boxes for target and inhibitory", 190, 410);
            page.drawString("spores, and set the inhibitory length", 190, 430);
            page.drawString("using the less and more buttons.", 190, 450);
            page.drawString("Press the RUN button to start.", 190, 470);
            page.drawString("Press help again to exit help.", 190, 490);
            // This is the text which is drawn onto the screen once the help
            // button is pressed. The text is contained within the speech marks,
            // and the position of each string is given by the co-ordinates.
        
    }
   }

  //===================================================================================== 
   public void actionPerformed( ActionEvent e)
   // This is the 'actionPerformed' method, which is used to detect any activity from the
   // user, such as entering numbers into the textboxes or pressing one of the buttons.
  //===================================================================================== 
   {
     
      if (e.getSource() == runButton)
      // This sets up an if statement which will only run if the run button is pressed. 
      // The e.getSource() is testing to see whether the run button is pressed.
      {
         boolean valid_input = true;
         // This creates a boolean variable called valid input, which is originally set to 
         // true. This will be used to indicate whether the numbers entered by the user are 
         // valid.
         String inhibtext = inhibit.getText();
         // This sets up a variable called inhibtext, and it gets the number of inhibition 
         // spores.
         inhibtext = inhibtext.trim();
         // This is a trim function, which removes blank spaces.
         try
         {
            numofBspores = Integer.parseInt (inhibtext);
            // This tries to convert the string to an integer, and then stores it in 
            // numofBspores. If string is not an integer, exception a is thrown, and the code 
            // below will run, generating an error message.
         }
         catch (Exception a)            
            // This exception catcher is used to detect any errors and will run if the value 
            // entered is not an integer.
         {
                JOptionPane.showMessageDialog(frame, 
                   "Please enter an integer between 1 and 100.", "Error", 
                   JOptionPane.ERROR_MESSAGE);
                // This code makes the error message appear. The text inside the first set of
                // speech marks is the text which will appear within the error message box, and 
                // the text inside the second set is what the error message will be called.
                valid_input = false;
                // This switches the valid input boolean to false, indicating that the data 
                // entered is invalid.
         }       
             
         String targettext = target.getText();
         // This sets up a variable called targettext, and it gets the number of target spores.
         targettext = targettext.trim();
         // This is a trim function, which removes blank spaces.
         try
         {
            numofAspores = Integer.parseInt (targettext);
            // This tries to convert the string to an integer, and then stores it in 
            // numofAspores. If string is not an integer, exception a is thrown, and 
            // the code below will run, generating an error message.
         }
         catch (Exception a)
         // This exception catcher is used to detect any errors and will run if the value entered 
         // is not an integer.
         {
                JOptionPane.showMessageDialog(frame, "Please enter an integer between 1 and 100.", 
                   "Error", JOptionPane.ERROR_MESSAGE);
                // This code makes the error message appear. The text inside the first set of 
                // speech marks is the text which will appear within the error message box, and 
                // the text inside the second set is what the error message will be called.
                valid_input = false;
                // This switches the valid input boolean to false, indicating that the data 
                // entered is invalid.
         }       
         
         if (numofBspores > maxnumofspores || numofBspores <= 0 || numofAspores > maxnumofspores 
            || numofAspores <= 0)
         // The numofBspores and numofAspores are the values which have been entered by the user. 
         // The statement above means that the code below will only run if one of those conditions
         // is met. The conditions are that either of the numbers entered are greater than the 
         // maximum number allowed to be enter (currently set at 100), or less than or equal to 0. 
             {
             JOptionPane.showMessageDialog(frame, "Please enter an integer between 1 and 100.", 
                "Error", JOptionPane.ERROR_MESSAGE);
             // This code makes the error message appear. The text inside the first set 
             // of speech marks is the text which will appear within the error message box, 
             // and the text inside the second set is what the error message will be called.
             valid_input = false;
             // This switches the valid input boolean to false, indicating that the data 
             // entered is invalid.
            }
         if (valid_input)    
            runon = true;
        // This 'if' functions means that if valid_input is true (i.e. a valid piece of data
        // has been entered, then the 'runon' variable becomes true, and this means this triggers 
        // the simulation to begin, as some of the earlier code will only run when 'runon' is true.
      }



      if (e.getSource() == lessButton)
      // This sets up an if statement and the code below will only be executed if the 'less' 
      // button is pressed. The e.getSource() is testing to see whether the 'less' button is 
      // pressed.
      {
       if (linelength > 5)
       // This sets up another if statement, which will only run if the variable linelength 
       // is greater than 5.
          linelength = linelength - 5;
       // This changes the value in the linelength variable, subtracting 5 from whatever it 
       // previously was. Therefore if the line is greater than 5, then the user is able to 
       // make it smaller.
          inhiblength = linelength;
       // This makes the value in the inhiblength the same as the value for linelength.
      }

      if (e.getSource() == moreButton) 
      // This sets up an if statement which will only run if the 'more' button is pressed. 
      // The e.getSource() is testing to see whether the 'more' button is pressed.
      {
       if (linelength < 80)
          // This sets up another if statement, and the code below will only be executed
          // if the variable linelength is greater than 5.
          linelength = linelength + 5;
          // This changes the value in the linelength variable, adding 5 to whatever it 
          // previously was. Therefore if the line is less than 80, the user can still 
          // add 5 to line, making it 5 units longer.
          inhiblength = linelength;
          // This makes the value in the inhiblength the same as the value for linelength,
          // and the inhiblength is then stored in the program for later use.
      }

      if (e.getSource() == helpButton) 
      // This sets up an if statement and the code below will only be executed if the 'help' 
      // button is pressed. The e.getSource() is testing to see whether the 'help' button 
      // is pressed.
      {
         helpon = !helpon;
         // This makes the boolean 'helpon' false.      
      }

       repaint();
       // This is used to refresh the screen and change the contents of any variables which 
       // have been changed.
   
   }
}
