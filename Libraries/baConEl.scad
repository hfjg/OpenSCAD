/**********************************************************
* SCAD construction library
*
* (C) 2018, Hermann Gebhard
*
*********************************************************/
$fn=72; eps=0.05;

function holeDia(d) = (d/cos(180/$fn));


// nut data according to DIN 934
// threadDia, wrenchWidth, nutHeight
nutData = [
    [1.6, 3.2, 1.3],
    [2, 4, 1.6],
    [2.5, 5 ,2], 
    [2.6, 5, 2],
    [3, 5.5, 2.4],
    [3.5, 6, 2.8],
    [4, 7, 3.2],
    [5, 8, 4],
    [6, 10, 5.2],
    [8, 13, 6.5],
    [10,17, 8],
];


_nww = [  for(i=[0:3]) let (th=nutData[i][0], ww=nutData[i][1]) [th,ww]   ];
_nh = [  for(i=[0:3]) let (th=nutData[i][0], nh=nutData[i][2]) [th,nh]   ];

function nutWrenchWidth(th) = lookup(th, _nww);
function nutHeight(th) = lookup(th, _nh);



module hexNut(threadDia){
    difference(){
        cylinder($fn=6, d=nutWrenchWidth(threadDia)/cos(30), h=nutHeight(threadDia), center=true);
       cylinder(d=threadDia, h=nutHeight(threadDia)+eps, center=true);
    }
}

/***********************************************************/
// xProfile(l=60, w=20, th=3)

module xProfile(l=60, w=20, th=3){
    intersection(){
        union(){
            rotate([0,0,+45])cube([2*w,th,l], center=true);
            rotate([0,0,-45])cube([2*w,th,l], center=true);
        }
        cube([w,w,l], center=true);
    }
}


/***********************************************************/
//donut(rTorus=10, rTube=3);

module donut(rTube, rTorus){
    rotate_extrude(angle=360)
        translate([rTorus,0,0])circle(r=rTube);
}

/***********************************************************/


module tube(do, di, h, center=false){
    difference(){
        cylinder(d=do, h=h, center=center);
        translate([0,0,-eps])cylinder(d=holeDia(di), h=h+2*eps, center=center);
    }
}

/***********************************************************/

module rectTube(w, h, l, wall){
    linear_extrude(l){
        difference(){
            square([w,h], center=true);
            square([w-2*wall,h-2*wall], center=true);
        }
    }
}

/***********************************************************/

module rowOfHoles(dia, numHoles, holeSpacing, holeHeight){
    for (i=[0:numHoles-1]) translate([0,i*holeSpacing,-eps])    cylinder(d=holeDia(dia), h=holeHeight+2*eps);
}

/***********************************************************/


module profile(hLeft, bottomWidth, hRight, thickness, length){
    translate([-bottomWidth/2,0,0]){
        cube([thickness, length, hLeft]);
        cube([bottomWidth,length,thickness]);
        translate([bottomWidth-thickness,0,0])cube([thickness, length, hRight]);
    }
}


/******************* Examples ******************************/
/***********************************************************/

/*
// wrench adapter
difference(){
    intersection(){
        translate([0,0,-0.5])sphere(d=19.4);
        translate([0,0,+0.5])sphere(d=19.4);
        translate([0,0,-5/2])difference(){
            cylinder(d=holeDia(17), h=5, $fn=6);
            translate([0,0,-eps])cylinder(d=holeDia(10), h=5+2*eps, $fn=6);
        }
    }
    translate([0,-17/2+1.7,5/2-0.5])linear_extrude(0.6)text("HG", font="Tex Gyre Heros", size=2, halign="center", valign="center");
}

// Profile with holes
difference(){
    profile(60,30,0,5,50);
    translate([0,12.5/2,0])rowOfHoles(dia=6, numHoles=2, holeSpacing=35, holeHeight=5);
}
*/
hexNut(2); translate([8,0,0]) 
!rotate([0,0,30])hexNut(3);

