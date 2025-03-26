function world_to_screen(x, y, z, view_mat, proj_mat, w = window_get_width(), h = window_get_height()) {
    /*
        Transforms a 3D world-space coordinate to a 2D window-space coordinate.
        Returns undefined if the 3D point is not in view
   
        Script created by TheSnidr
        www.thesnidr.com
    */
    var cx, cy;
    if (proj_mat[15] == 0) {   //This is a perspective projection
        var ww = view_mat[2] * x + view_mat[6] * y + view_mat[10] * z + view_mat[14];
        if (ww <= 0) return undefined;
        cx = proj_mat[8] + proj_mat[0] * (view_mat[0] * x + view_mat[4] * y + view_mat[8] * z + view_mat[12]) / ww;
        cy = proj_mat[9] + proj_mat[5] * (view_mat[1] * x + view_mat[5] * y + view_mat[9] * z + view_mat[13]) / ww;
    } else {    //This is an ortho projection
        cx = proj_mat[12] + proj_mat[0] * (view_mat[0] * x + view_mat[4] * y + view_mat[8]  * z + view_mat[12]);
        cy = proj_mat[13] + proj_mat[5] * (view_mat[1] * x + view_mat[5] * y + view_mat[9]  * z + view_mat[13]);
    }
    
    return new Vector3((0.5 + 0.5 * cx) * w, (0.5 - 0.5 * cy) * h, 0);
};