/*
date: 20120415

Points to places
...a little science visualisation...

a little Processing sketch where
there are some circles that are attached
to points (the destination points here),
by an elastic 'string'.
initially there's no drag or resistance,
so the circles move around the destination 
points like a perpetual pendulum.

also initially the size of the circle is
a reflection of their velocity.
the faster they move, the larger they
become.
 
 */




// lifesaver
int debug = 2;

//  lifesaver2
import processing.opengl.* ; 


// __________ classes

// destination locations
Destination_locations destination_locations;

// and the moving points 
Moving_pts moving_points ;


// ____________________

//  what to draw?
//  do we draw only the moving points, or also the attachment lines and destination points?
boolean draw__destination_points = true;
boolean draw__lines_btw_dest_and_moving_pts = true;
boolean draw__moving_pts = true;



// ______________________________________________


void setup() {
  size( 1000, 1000, OPENGL );
  frameRate( 25 );

  background( 255 );

  // ___ destination points play
  setup_dest_pts();
  setup_moving_pts();

  //
  ///   noLoop();
}


// _________________________________________________



void draw() {

  background( 255 );



  //  draw --  destination points?
  if ( draw__destination_points ) {
    destination_locations.draw_pts();
  }

  // ___ moving points - update and draw them

  // update
  moving_points.update_moving_pts_positions();



  //  draw -- lines btw destination points and moving points?
  if ( draw__lines_btw_dest_and_moving_pts ) {
    moving_points.test_draw_lines_btw_moving_pts_and_dest_pts();
  }
  //  draw --  moving points?... yes!
  if ( draw__moving_pts ) {
    moving_points.draw_pts() ;
  }

  //
}





// ====================================================


void setup_dest_pts() {

  // instantiate
  destination_locations = new Destination_locations();

  // put some destination points
  destination_locations.setup_rect_grid();
  destination_locations.draw_pts();
}



// _________________________________________



void setup_moving_pts() {

  // instantiate
  moving_points = new Moving_pts();

  //  tell it where the destination points are
  moving_points.dest_pts_class = destination_locations;


  // fix some of the class setups
  moving_points.setup_pts();

  //  more array value setups
  moving_points.setup_max_velocity_n_dampening_n_colors() ;


  // __________ setup random locations and draw the moving points

    // __ setup some random point locations
  // figure out the location and spread from it
  PVector start_pt_distrib_loc = new PVector( 1500, 750 );
  float max_pt_dist_from_start_pt = 25*2;
  // put some points at a random location
  moving_points.setup_point_locations__as_pts_at_random_given_max_dist_from_given_loc( 
  start_pt_distrib_loc, max_pt_dist_from_start_pt );

  // draw the points ?
  moving_points.draw_pts() ;


  // ____________   find some random destinations and draw the connection 
  //                 btw the moving pts and destinations
  // find some random destination points?
  moving_points.find_new_destination_pts_for_moving_pts();

  // draw the lines between the moving points and the destination points? 
  moving_points.test_draw_lines_btw_moving_pts_and_dest_pts();

  //    //  move the drawing points?
  moving_points.update_moving_pts_positions();
}


// _____________________   keyboard interaction  _____________________  




void keyReleased() {

  //  reset the play
  if ( key == 'r' || key == 'R' )
  {
    setup_moving_pts();
  }


  //  give the points new destinations?
  if ( key == 'd' || key == 'D' ) {
    moving_points.find_new_destination_pts_for_moving_pts();
  }


  // the shape form vs velocity

  //  simple - just change whether the form changes according to velocity
  //           BUT maintain the current shape
  if ( key == 's' ) {
    // change the boolean
    moving_points.change_point_size_acc_to_velocity = !moving_points.change_point_size_acc_to_velocity ;
    println(" moving_points.change_point_size_acc_to_velocity = "+moving_points.change_point_size_acc_to_velocity );
  }

  //  complex - as above but resetting the shape form to the original
  if ( key == 'S' ) {
    // change the boolean
    moving_points.change_point_size_acc_to_velocity = !moving_points.change_point_size_acc_to_velocity ;
    // and reset the sizes
    moving_points.reset_point_radiuses();
    println(" reset the point sizes plus moving_points.change_point_size_acc_to_velocity = "+moving_points.change_point_size_acc_to_velocity );
  }


  //  modifier key fun  - DRAG  |  MAX VELOCITY 
  if (key == CODED) {

    //  DRAG on/off?!
    if (keyCode == ALT) {
      moving_points.dampen_speed = !moving_points.dampen_speed ;
      println(" dampen_speed = "+moving_points.dampen_speed );
    }

    // modify DRAG QUANTITY 
    //   DRAG == LARGER
    if (keyCode == UP) {
      // increase the constant factor
      moving_points.constant_dampening_value += moving_points.constant_dampening_speed__incrementor ;
      // then change the value of this for all the points
      moving_points.change_dampening_factor_of_all_points();
      println(" increased drag speed - now moving_points.constant_dampening_value == "+moving_points.constant_dampening_value );
    }
    //    DRAG == SMALLER
    if (keyCode == DOWN) {
      // increase the constant factor
      moving_points.constant_dampening_value -= moving_points.constant_dampening_speed__incrementor ;
      // then change the value of this for all the points
      moving_points.change_dampening_factor_of_all_points();
      println(" decreased drag speed - now moving_points.constant_dampening_value == "+moving_points.constant_dampening_value );
    }



    // modify MAX VELOCITY
    //   MAX VELOCITY == LARGER
    if (keyCode == RIGHT) {
      // increase the constant factor
      moving_points.constant_max_velocity += moving_points.constant_max_velocity__incrementor ;
      // then change the value of this for all the points
      moving_points.change_max_allowed_velocity_for_all_points();
      println(" decreased max velocity - now constant_max_velocity == "+moving_points.constant_max_velocity );
    }
    //    MAX VELOCITY == SMALLER
    if (keyCode == LEFT) {
      // decrease the constant factor
      moving_points.constant_max_velocity -= moving_points.constant_max_velocity__incrementor ;
      // then change the value of this for all the points
      moving_points.change_max_allowed_velocity_for_all_points();
      println(" decreased max velocity - now constant_max_velocity == "+moving_points.constant_max_velocity );
    }
  }




  // ___ toggle WHAT TO DRAW

  //  draw the DESTINATION POINTS?   
  if ( key == '1' ) {
    draw__destination_points = !draw__destination_points ;
    println("   draw__destination_points == "+draw__destination_points );
  }  

  //  draw the LINES between the destination and moving points?   
  if ( key == '2' ) {
    draw__lines_btw_dest_and_moving_pts = !draw__lines_btw_dest_and_moving_pts ;
    println("   draw__lines_btw_dest_and_moving_pts == "+draw__lines_btw_dest_and_moving_pts );
  }

  //  draw the MOVING POINTS?   
  if ( key == '3' ) {
    draw__moving_pts = !draw__moving_pts ;
    println("   draw__moving_pts == "+draw__moving_pts );
  }


  //
}



// _____________________    mouse interaction     _____________________  





//  release the points from the mouseLoc?
void mouseReleased() {

  //  restart the points from where the mouse is pressed
  moving_points.setup_point_locations__as_pts_at_random_given_max_dist_from_given_loc( 
  new PVector( mouseX, mouseY), 25 );
}

