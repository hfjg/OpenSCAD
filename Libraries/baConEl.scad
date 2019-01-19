/***********************************************************
* baConEl.scad
* Library of basic construction elements
* (C) 2019, Hermann Gebhard
*
*************************************************************/
$fn=72;
eps=0.05;

function norm(v)=sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);

module circleof(num=6, r=10, center=[0,0,0], 
        startAngle=0, deltaAngle=0){
        _dphi = (deltaAngle==0) ? (360)/num : deltaAngle;

        translate(center)rotate([0,0,startAngle])
        for (_n=[0:num-1])
        rotate([0,0,_n*_dphi]) translate([r,0,0]) {
            for (i=[0:$children-1])children(i);
        }
}

module rowof(num=6, distance=10, start=[0,0,0], dir=[1,0,0]){
    
    _t = distance*dir/norm(dir);
    for(j=[0:num-1]){
        translate(start + j*_t) 
        for (i=[0:$children-1])children(i);
        }
}

module luProfile (hLeft=20, width=30, hRight=20, length=40, thick=5){
    cube([thick, length, hLeft]);
    cube([width, length, thick]);
    translate([width-thick,0,0])cube([thick, length, hRight]);
}

module xProfile(width=30, height=30, length=50, thick=4){
    _diagonal = sqrt(width*width+height*height);
    _phi = atan(height/width);
    translate([0,length/2,0])intersection(){
        cube([width, length, height], center=true);
        
        union(){
            rotate([0, _phi,0])cube([_diagonal, length, thick], center=true);
            rotate([0,-_phi,0])cube([_diagonal, length, thick], center=true);
        }
    }
}

module donut(di, do, ri=0, ro=0){
    _ri = (ri==0) ? di/2 : ri;
    _ro = (ro==0) ? do/2 : ro;
    rotate_extrude()translate([_ri+_ro,0]) 
        circle(r=_ro-_ri);
}

module tube(di=0, do=0, length=10,  wall=0){
    _do = (do==0) ? di + 2*wall : do;
    _di = (di==0) ? do - 2*wall : di;
    difference(){
        cylinder(d=_do, h=length);
        hole (d=_di, h=length);
    }
}

module rectTube(width, height, length, wall){
    translate([0,length/2,0])difference(){
        cube([width, length, height], center=true);
        cube([width-2*wall, length+eps, height-2*wall], center=true);
    }
}


module hole(d=4, h=10, holeCorrect=0.4){
    translate([0,0,-eps]) cylinder(d=d+holeCorrect, h=h+2*eps);
}

module fixeye(h=20, r=8, thick=5, drill=3){
    difference(){
        union(){
            cylinder(r=r, h=thick);
            translate([-r,-h+r,0])cube([2*r, h-r, thick]);
        }
        hole(d=drill, h=thick);
    }
}


/********** examples *********************************/
/*
fixeye(h=20, r=5, drill=6);

scale([1,1,4])donut(di=20,do=26);

circleof(r=20) cylinder(d=3,h=10);

color("red")circleof(r=30, num=12, center=[30,20,0], startAngle=0, deltaAngle=0) cylinder(d=4, $fn=6, h=10);

rowof(num=3, distance=30) cylinder(d=4,h=16, center=true);
*/