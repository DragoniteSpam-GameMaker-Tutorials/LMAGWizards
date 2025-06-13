function Aquila() constructor {
    static AquilaNode = function(data) constructor {
        static node_counter = 0;
        
        self.data = data;
        self.connections = { };
        self.id = string(node_counter++);
        self.enabled = true;
        
        static GetConnections = function() {
            var keys = variable_struct_get_names(self.connections);
            var connections = array_create(array_length(keys));
            for (var i = 0, n = array_length(keys); i < n; i++) {
                connections[i] = self.connections[$ keys[i]];
            }
            return connections;
        };
        
        static Enable = function(enabled) {
            self.enabled = enabled;
        };
        
        static GetEnabled = function() {
            return self.enabled;
        };
        
        static Connect = function(node, cost, bidirectional) {
            var this_node = self;
            self.connections[$ node.id] = { source: this_node, destination: node, cost: cost };
            if(bidirectional) {
                node.Connect(self, cost, false);
            }
        };
        
        static Disconnect = function(node) {
            if (variable_struct_exists(self.connections, node.id)) {
                variable_struct_remove(self.connections, node.id);
            }
            if (variable_struct_exists(node.connections, self.id)) {
                variable_struct_remove(node.connections, self.id);
            }
        };
    };
    
    static AquilaResult = function(route, stops, total_cost) constructor {
        self.route = route;
        self.stops = stops;
        self.total_cost = total_cost;
    };
    
    self.nodes = { };
    
    /// @return {struct.AquilaNode}
    static AddNode = function(data) {
        var node = new self.AquilaNode(data);
        self.nodes[$ node.id] = node;
        return node;
    };
    
    /// @param {struct.AquilaNode} node
    static RemoveNode = function(node) {
        if (variable_struct_exists(self.nodes, node.id)) {
            variable_struct_remove(self.nodes, node.id);
            // struct_foreach wasn't working properly for some values for some reason
            var keys = struct_get_names(node.connections);
            for (var i = 0, n = array_length(keys); i < n; i++) {
                var connection = node.connections[$ keys[i]];
                connection.source.Disconnect(connection.destination);
            }
        }
    };
    
    /// @param {struct.AquilaNode} a
    /// @param {struct.AquilaNode} b
    /// @param {real} cost
    /// @param {bool} bidirectional
    static ConnectNodes = function(a, b, cost = 1, bidirectional = true) {
        a.Connect(b, cost, bidirectional);
    };
    
    /// @param {struct.AquilaNode} a
    /// @param {struct.AquilaNode} b
    static DisconnectNodes = function(a, b) {
        a.Disconnect(b);
        b.Disconnect(a);
    };
    
    static ClearNodes = function() {
        self.nodes = { };
    };
    
    /// @return {array<struct.AquilaNode>}
    static GetAllNodes = function() {
        var keys = variable_struct_get_names(self.nodes);
        /// {array<struct.AquilaNode>}
        var nodes = array_create(array_length(keys));
        for (var i = 0, n = array_length(keys); i < n; i++) {
            nodes[i] = self.nodes[$ keys[i]];
        }
        return nodes;
    };
    
    /// @return {real}
    static Size = function() {
        return variable_struct_names_count(self.nodes);
    };
    
    /// @param {struct.AquilaNode} source
    /// @param {struct.AquilaNode} destination
    /// return {struct.AquilaResult|undefined}
    static Navigate = function(source, destination) {
        var t = source;
        source = destination;
        destination = t;
        
        static frontier = ds_priority_create();
        ds_priority_clear(frontier);
        var came_from = { };
        var costs = { };
        
        ds_priority_add(frontier, source, 0);
        
        // this one doesnt work but in a different way...
        while (!ds_priority_empty(frontier)) {
            var current = ds_priority_delete_min(frontier);
            if (!current.enabled) continue;
            
            if (current == destination) {
                var path = [destination];
                var total_cost = 0;
                while (current != source) {
                    total_cost += current.connections[$ came_from[$ current.id].id].cost;
                    current = came_from[$ current.id];
                    array_push(path, current);
                }
                return new self.AquilaResult(path, array_length(path), total_cost);
            }
            
            var neighbor_ids = variable_struct_get_names(current.connections);
            for (var i = 0, n = array_length(neighbor_ids); i < n; i++) {
                var neighbor = neighbor_ids[i];
                var cost_current = costs[$ current.id];
                var cost_neighbor = costs[$ neighbor];
                cost_current ??= 0;
                cost_neighbor ??= 0;
                var cost_tentative = cost_current + current.connections[$ neighbor].cost;
                
                if (!came_from[$ neighbor] || cost_tentative < cost_neighbor) {
                    came_from[$ neighbor] = current;
                    costs[$ neighbor] = cost_tentative;
                    ds_priority_add(frontier, self.nodes[$ neighbor], cost_tentative);
                }
            }
        }
        
        return undefined;
    };
}