class Moving_pts {



  // ___________ reference to the destination pts class

    Destination_locations dest_pts_class;



  // ____________ point quantity, etc..


  int num_of_pts = 1000;



  // _____________ movement


  //  which is the point's current location
  PVector[] point_locs ;


  // which point is each point aiming for?
  int[] destination_point_i_for_moving_pt ;

  //  the current velocity
  PVector[] point_velocities ;

  // how quick could we possible move
  float[] max_velocity ;
  float constant_max_velocity = 15;  // to be lazy we'll just use a single value for now
  float constant_max_velocity__incrementor = 5; //  if we change the max velocity, do it by this quantity?
  //  but make it possible to adjust things individually

  //   accelleration
  float[] max_accelleration ;
  float constant_max_acc = 0.5;


  // dampening
  boolean dampen_speed = false;
  float[] dampening_factor;
  float constant_dampening_value = 0.99; // to be lazy we'll just use a single value for now
  float constant_dampening_speed__incrementor = 0.05 ;  //  if we change the 
  //  dampening speed, it's by this quanity
  //  but make it possible to adjust things individually



  // ____________ visual markup  __________



  // _____ for the moving points

  boolean change_point_size_acc_to_velocity = true;
  float[] point_radius ;
  float constant_point_radius = 5;
  color[] points_colors ;
  color constant_color_val = color( 255, 0, 0, 64);

  float[] stroke_widths ;
  float constant_stroke_width = 1;

  // ___ for the lines between the moving points and their destinations

  color line_btw_moving_pts_and_destinations__color = color( 0, 255, 0, 12 );
  float line_btw_moving_pts_and_destinations__strokeWidth = 1 ;



  // __________________________ constructor _______________


  Moving_pts( ) {
    println(" Moving_pts:  yaya! we just set one up" );
  }


  // =======================================================


  void setup_pts() {

    //  set up their space
    destination_point_i_for_moving_pt = new int[ num_of_pts ];
    point_locs = new PVector[ num_of_pts ];    
    point_velocities = new PVector[ num_of_pts ];    
    max_velocity = new float[ num_of_pts ];    
    max_accelleration = new float[ num_of_pts ];    
    dampening_factor = new float[ num_of_pts ];
    points_colors = new color[ num_of_pts ];
    stroke_widths = new float[ num_of_pts ];
    point_radius = new float[ num_of_pts ];
  }


  // _______________________________


  // setup the max speed and dampening individually
  //   as this might or might not be needed for the other functionality
  void setup_max_velocity_n_dampening_n_colors() {

    for ( int i = 0 ; i < num_of_pts ; i++ ) {
      point_velocities[i] = new PVector( 0, 0 );
      max_velocity[i] = constant_max_velocity;
      max_accelleration[i] = constant_max_acc;
      dampening_factor[i] = constant_dampening_value;
      points_colors[i] = constant_color_val ;
      stroke_widths[i] = constant_stroke_width ;
      point_radius[i] = constant_point_radius ;
    }
    //
  }


  // _______________________________


  /*
change the max allowed velocity 
   */

  void change_max_allowed_velocity_for_all_points() {

    for ( int i = 0 ; i < num_of_pts ; i++ ) {
      max_velocity[i] = constant_max_velocity;
    }
  }


  // __________________________________

  /*
change the dampening factor of the points 
   */


  void change_dampening_factor_of_all_points() {

    // now loop and change the velocities of all the points

      for ( int i = 0 ; i < num_of_pts ; i++ ) {
      dampening_factor[i] = constant_dampening_value;
    }
    //
  }


  // _______________________________



  /*
reset the radius of the points   
   */

  void reset_point_radiuses() {

    for ( int i = 0 ; i < num_of_pts ; i++ ) {
      point_radius[i] = constant_point_radius ;
    }
  }



  // _______________________________



  /*
distributes the points locations, in different ways
   
   case:
   kind_of_location_setup == "random_around_pt_loc" - put points at a max dist from x,y
   kind_of_location_setup == "rect areas" - put points in a grid array 
   */

  void setup_point_locations__as_pts_at_random_given_max_dist_from_given_loc( PVector start_loc, float max_dist_from_given_loc ) {

    // make some space for them
    //// point_locs = new PVector[ num_of_pts ];

    for ( int i = 0; i < point_locs.length ; i++ ) {

      point_locs[i] = new PVector();

      // find the random distance    
      float curr_max_dist = random( max_dist_from_given_loc );
      // find a random angle 
      float random_angle_from_start_pt = random( TWO_PI );
      // compute the location ( minus offset )
      point_locs[i].x = cos( random_angle_from_start_pt ) * curr_max_dist;
      point_locs[i].y = sin( random_angle_from_start_pt ) * curr_max_dist;

      if ( debug > 3 ) {
        println(" \n setup_point_locations__as_pts_at_random_given_max_dist_from_given_loc = new pt a loc "+point_locs[i].x+", "+point_locs[i].y );
      }

      // add the starting point offset finally
      point_locs[i].add( start_loc );

      if ( debug > 3 ) {
        println(" and the final point loc == "+point_locs[i].x+", "+point_locs[i].y );
      }
    }
  }



  //   _____________________________________________


  /*
finds new destinations - in the form of destination point indicies - 
   for the moving points
   */

  void find_new_destination_pts_for_moving_pts() {

    //  how many destination points are there again?
    float num_of_dest_pts = dest_pts_class.locs.length ;

    for ( int i = 0; i < point_locs.length; i++ ) {

      destination_point_i_for_moving_pt[i] = (int) random( num_of_dest_pts );
    }
    //
  }



  //  _____________________________________________



  /*
draw some joining lines between the moving points and their destination point locations
   */

  void test_draw_lines_btw_moving_pts_and_dest_pts() {

    stroke( line_btw_moving_pts_and_destinations__color );
    strokeWeight( line_btw_moving_pts_and_destinations__strokeWidth );

    for ( int i = 0; i < point_locs.length; i++ ) {
      line( point_locs[i].x, point_locs[i].y, 
      dest_pts_class.locs[ destination_point_i_for_moving_pt[i] ].x, dest_pts_class.locs[ destination_point_i_for_moving_pt[i] ].y );
    }
    //
  }


  // _____________________________________________


  /*
  
   update the moving poin positions 
   - vis a vis moving towards their destinations 
   - vis a vis the forcefields of the other points
   
   how?
   
   - vis a vis the destinations...
   -- drag?!?!?!? on velocity?
   -- find the vector to the destination 
   -- if the vector to the destination is smaller than the normalised vector,
   just use the non-normalised vector
   -- add the vector to the velocity, if the velocity is not too high. 
   -- //   max vel = normalised velocity * maxVel?!?!?
   
   */

  void update_moving_pts_positions() {

    //  loop through each point and figure out how it should move
    for ( int i = 0; i < point_locs.length; i++ ) {

      // figure out the vector to the destination point 
      //  ( destination loc - current locs )
      PVector vector_to_dest = PVector.sub( dest_pts_class.locs[ destination_point_i_for_moving_pt[i] ], point_locs[i] );
      // float vect_to_dest_normalised = vector_to_dest.normalize();

      //  find the accelleration to the destination, according to our max speed
      //    - find the normalised vector to the destination
      //    - multiply the normalised vector to dest, by the max accelleration speed

      if ( debug > 3 ) {
        println(" update_moving_pts_positions() : vector_to_dest = "+vector_to_dest );
      }
      // so, normalise something 
      vector_to_dest.normalize();

      //  find the relevant max accelleration 
      PVector vector_to_dest__as_max_accelleration_to_there = 
        new PVector( vector_to_dest.x * max_accelleration[i], vector_to_dest.y * max_accelleration[i] ); 

      // feedback
      if ( debug > 3) {
        println("   vector_to_dest.normalized = "+vector_to_dest+"  vector_to_dest__as_max_accelleration_to_there = "+vector_to_dest__as_max_accelleration_to_there+" ( max acc == "+max_accelleration[i]+" ) " );
      }

      //  add the accelleration to the velocity
      point_velocities[i].add( vector_to_dest__as_max_accelleration_to_there );

      if ( debug > 3 ) {
        println(" point_velocities[i] = "+point_velocities[i] );
      }
      //   add the magneticism to other points?!??! to the velocity?


      //  make sure the velocity is not too hight... 
      float this_point_velocity = point_velocities[i].mag();
      if ( this_point_velocity > max_velocity[i] ) {
        // normalise the velocity
        point_velocities[i].normalize();

        // and multiply it by the max velocity
        point_velocities[i].mult( max_velocity[i] );
      }

      ///////////  EXPERIMENT ZONE     ///////////////////////////
      ///////////  EXPERIMENT ZONE   ////////////////////

      //  introduce drag to the max velocity 
      if ( dampen_speed ) {
        point_velocities[i].mult( dampening_factor[i] );
      }

      //  change the point size depending on the velocity
      if ( change_point_size_acc_to_velocity ) {
        point_radius[i] = constant_point_radius * this_point_velocity ;
      }

      ///////////////////////////////////////
      //////////////////////////////////////

      // ______ finally _______ update the position 
      point_locs[i].add( point_velocities[i] );



      ////   for the next loop ______________________________________

      //   zero the accelleration! .... errr... well that variable gets reset on each loop!
      //     so no particular need
    }
  }



  // _____________________________________________



  void draw_pts() {

    //  set the colours right
    noFill();

    // loop and draw
    for ( int i = 0; i < point_locs.length; i++ ) {

      //// fill( 255, 0, 0, 128 );

      //  setup the colors
      stroke( points_colors[i] );
      //  and the strokeweight
      strokeWeight( stroke_widths[i] );

      // finally draw
      ellipse( point_locs[i].x, point_locs[i].y, point_radius[i], point_radius[i] );
    }
    //
  }


  // _________________________________________  end of class
}

