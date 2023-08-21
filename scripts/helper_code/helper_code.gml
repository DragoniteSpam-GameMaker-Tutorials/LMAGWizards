function array_search_with_name(array, name) {
    var index = array_find_index(array, method({ name }, function(shape) {
        return shape.name == self.name;
    }));
    
    if (index == -1) return undefined;
    
    return array[index];
}