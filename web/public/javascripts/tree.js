function TreeData() {
  this.nodes = {};
}

TreeData.prototype = {
  addLeaf: function(name, value) {
    this.nodes[name] = value;
  },

  addBranch: function(name) {
    return this.nodes[name] = new TreeData();
  },

  addList: function(name) {
    return this.nodes[name] = new ListData();
  },

  rename: function(oldName, newName) {
    this.nodes[newName] = this.nodes[oldName];
    delete this.nodes[oldName];
  },

  replace: function(name, newValue) {
    this.nodes[name] = newValue;
  },

  remove: function(name) {
    delete this.nodes[name];
  },

  toHash: function() {
    var hash = {};

    for (n in this.nodes) {
      var v = this.nodes[n];

      if (v.toHash) {
        hash[n] = v.toHash();
      } else {
        hash[n] = v;
      }
    }

    return hash;
  }
}

function ListData() {
  this.nodes = [];
}

ListData.prototype = {
  addBranch: function() {
    var subData = new TreeData();
    this.nodes.push(subData);
    subData._listIndex = this.nodes.length - 1;
    return subData;
  },

  remove: function(subData) {
    this.nodes.splice(subData._listIndex, 1);

    for (n in this.nodes) {
      this.nodes[n]._listIndex = n;
    }
  },

  toHash: function() {
    var array = [];

    for (n in this.nodes) {
      var v = this.nodes[n];

      if (v.toHash) {
        array.push(v.toHash());
      } else {
        array.push(v);
      }
    }
    return array;
  }
}

$.widget('ui.list', {
  options: { data: null },

  _create: function() {
    if (this.options.data) {
      this.data = this.options.data;
    } else {
      this.data = new ListData();
    }

    this.tree_html = $('<ul class="list"></ul>');

    var branch_form = $('<form action="#" class="add-branch"></form>');
    branch_form.append('<input type="submit" value="List Elem", class="done"/>');

    branch_form.data('list', this);
    branch_form.submit(function(e) {
      e.preventDefault();
      branch_form.data('list').addBranch();
    });

    $(this.element).append(this.tree_html);
    $(this.element).append(branch_form);
  },

  addBranch: function() {
    var subData = this.data.addBranch();
    var member = $("<li class='member'><form><button class='delete'>Delete</button></form><div class='list-member-holder'></div></li>");
    var d = this.data;

    member.find('.delete').click(function(e) {
      e.preventDefault();
      d.remove(subData);
      // without a timeout, member.remove() causes test suite
      // page to reload infinitely in safari
      setTimeout(function() {member.remove()}, 0);
    });

    member.find('.list-member-holder').tree({data: subData});
    this.tree_html.append(member);
  },

  treeData: function() {
    return this.data.toHash();
  }
});

$.widget('ui.tree', {
  options: { data: null },

  _create: function() {
    if (this.options.data) {
      this.data = this.options.data;
    } else {
      this.data = new TreeData();
    }

    this.tree_html = $('<ul class="branch"></ul>');

    var node_form = $('<form action="#" class="add-leaf"></form>');
    node_form.append('Name: <input type="text" name="name" class="name"/>');
    node_form.append('Value: <input type="text" name="value" class="value"/>');
    node_form.append('<input type="submit" value="Value", class="done"/>');

    node_form.data('tree', this);
    node_form.submit(function(e) {
      e.preventDefault();
      var name = node_form.find('.name').val();
      var value = node_form.find('.value').val();
      node_form.data('tree').addLeaf(name, value);
    });

    var branch_form = $('<form action="#" class="add-branch"></form>');
    branch_form.append('Name: <input type="text" name="name" class="name"/>');
    branch_form.append('<input type="submit" value="Sub-Tree", class="done"/>');

    branch_form.data('tree', this);
    branch_form.submit(function(e) {
      e.preventDefault();
      branch_form.data('tree').addBranch(branch_form.find('.name').val());
    });

    var list_form = $('<form action="#" class="add-list"></form>');
    list_form.append('Name: <input type="text" name="name" class="name"/>');
    list_form.append('<input type="submit" value="List", class="done"/>');

    list_form.data('tree', this);
    list_form.submit(function(e) {
      e.preventDefault();
      list_form.data('tree').addList(list_form.find('.name').val());
    });

    $(this.element).append(this.tree_html);
    $(this.element).append(node_form);
    $(this.element).append(branch_form);
    $(this.element).append(list_form);
  },

  treeData: function() {
    return this.data.toHash();
  },

  addLeaf: function(name, value) {
    this.data.addLeaf(name, value)
    var treeData = this.data;
    var node = this._buildNode(name);
    node.find('form').append("<input class='value' type='text'>");
    node.find('.value').val(value);

    node.bind('name-changed', function(e, data) {
      name = data.newName;
    });

    node.find('.value').change(function(e) {
      e.preventDefault();
      treeData.replace(name, node.find('.value').val());
    });

    this.tree_html.append(node);
  },

  addBranch: function(name) {
    var subData = this.data.addBranch(name);
    var node = this._buildNode(name);
    node.tree({data: subData});
    this.tree_html.append(node);
  },

  addList: function(name) {
    var subData = this.data.addList(name);
    var node = this._buildNode(name);
    node.list({data: subData});
    this.tree_html.append(node);
  },

  _buildNode: function(name) {
    var node = $("<li class='node'><form><button class='delete'>Delete</button><input class='name' type='text'></input></form></li>");

    node.find('.name').val(name);

    (function(data) {
      node.find('.name').change(function(e) {
        e.preventDefault();
        var newName = node.find('.name').val();
        var oldName = name;
        data.rename(oldName, newName);
        name = newName;
        node.trigger('name-changed', {oldName: oldName, newName: newName});
      })

      node.find('.delete').click(function(e) {
        e.preventDefault();
        data.remove(name);
        node.remove();
      });
    })(this.data);

    return node;
  }
});
