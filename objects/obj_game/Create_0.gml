vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
self.vertex_format = vertex_format_end();

var buffer = buffer_load("block_singular.vbuff");
self.block = vertex_create_buffer_from_buffer(buffer, self.vertex_format);
vertex_freeze(self.block);
buffer_delete(buffer);