$.widget('ui.tree', {
  _create: function() {
    this.data = {};

    this.tree_html = $('<ul class="branch"></ul>');

    var node_form = $('<form action="#" class="add-node"></form>');
    node_form.append('Name: <input type="text" name="name" class="name"/>');
    node_form.append('Value: <input type="text" name="value" class="value"/>');
    node_form.append('<input type="submit" value="Value", class="done"/>');

    node_form.data('tree', this);
    node_form.submit(function(e) {
      e.preventDefault();
      node = {};
      node[node_form.find('.name').val()] = node_form.find('.value').val();
      node_form.data('tree').addNode(node);
    });

    var branch_form = $('<form action="#" class="add-branch"></form>');
    branch_form.append('Name: <input type="text" name="name" class="name"/>');
    branch_form.append('<input type="submit" value="Sub-Tree", class="done"/>');

    branch_form.data('tree', this);
    branch_form.submit(function(e) {
      e.preventDefault();
      branch_form.data('tree').addBranch(branch_form.find('.name').val());
    });

    $(this.element).append(this.tree_html);
    $(this.element).append(node_form);
    $(this.element).append(branch_form);
  },

  treeData: function() {
    var treeData = {};

    for (n in this.data) {
      var v = this.data[n];


      if (typeof(v) == "function") {
        treeData[n] = v();
      } else {
        treeData[n] = v;
      }
    }

    return treeData;
  },

  addNode: function(data) {
    $.extend(this.data, data);
    for(name in data) {
      var leaf = $("<li class='leaf'><span class='name'></span><span class='value'></span></li>");
      leaf.find('.name').html(name);
      leaf.find('.value').html(data[name]);
      this.tree_html.append(leaf);
    }
  },

  addBranch: function(name) {
    this.data[name] = function() {
      return leaf.data('tree').treeData();
    }

    var leaf = $("<li class='leaf'><span class='name'></span></li>");
    leaf.find('.name').html(name);
    leaf.tree();
    this.tree_html.append(leaf);
  }
});
