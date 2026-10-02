var all_things_index = array_get_index(global.all_things, self.id);
if (all_things_index >= 0) {
    array_delete(global.all_things, all_things_index, 1);
}