

class Destination_locations {


  //  how many locations
  int num_of_locs = 100;
  //   somewhere to hold the locations
  PVector[] locs;

  // _______ rect grid parameters
  int num_of_columns = 10;

  //  ______  coordinates of the loc grid
  PVector dest_pts_grid_top_left = new PVector( 200, 200 );

  float dest_pts_grid_col_width_x = 50;
  float dest_pts_grid_row_height_y = 50;  


  // _______ the forcefield parameters

  // how far does the forcefield of the points reach?
  float[] dest_pts_forcefield_range ;
  float dest_pts_forcefield_range__constant_value = 100 ;

  //  and how much of a max push does it have?
  //  (I think we're calculating the force in an existential way
  //      ... this should be the max force
  float[] maxforce_of_dest_pts_forcefield ;
  float maxforce_of_dest_pts_forcefield__constant_constant_value = 5;

  // ___________ constructor ______________________


  Destination_locations() {
    println(" yay, set up a destination locations master controller! ");
  }


  // ===================================== class methods



  void setup_forcefield_params() {

    //   setup the place for the params
    dest_pts_forcefield_range = new float[ num_of_locs ];
    maxforce_of_dest_pts_forcefield = new float[ num_of_locs ];

    //  loop and set up the destination points individually individually
    for ( int i = 0; i < num_of_locs; i++ ) {

      dest_pts_forcefield_range[i] = dest_pts_forcefield_range__constant_value ;
      maxforce_of_dest_pts_forcefield[i] = maxforce_of_dest_pts_forcefield__constant_constant_value ;
    }
    //
  }


  // ____________________________________________

  void setup_rect_grid() {

    //  just a lookup value to remember how wide the grid is 
    float total_grid_width = num_of_columns * dest_pts_grid_col_width_x;

    //   setup the holders of the locations, pvectors
    locs = new PVector[ num_of_locs ];

    //  loop and set up the destination points individually individually
    for ( int i = 0; i < locs.length; i++ ) {

      // make the point
      locs[i] = new PVector();

      // __ figure out the location
      locs[i].x = ( i % num_of_columns ) * dest_pts_grid_col_width_x ;
      locs[i].y = int( i / num_of_columns ) * dest_pts_grid_row_height_y;


      if ( debug > 3 ) {
        println(" setup_rect_grid() - point #"+i+" go loc "+locs[i].x+", "+locs[i].y+"  plus the offset ");
        if ( i != 0 ) {
          println(" ( num_of_columns % i ) == "+( num_of_columns % i )+" \n ");
        }
      }

      // add the offset
      locs[i].add( dest_pts_grid_top_left );
    }
  }



  // _____________________________________________


  void draw_pts() {

    for ( int i = 0 ; i < locs.length; i++ ) {

      fill( 200, 32 );
      stroke( 200, 128 );
      strokeWeight( 1 );
      ellipse( locs[i].x, locs[i].y, 10, 10 );
    }
  }



  //   end of class
}

