$.widget('ui.tree', {
  _create: function() {
    this.data = {};

    this.tree_html = $('<ul class="branch"></ul>');

    var form = $('<form action="#" class="add-node"></form>');
    form.append('Name: <input type="text" name="name" class="name"/>');
    form.append('Value: <input type="text" name="value" class="value"/>');
    form.append('<input type="submit" value="Done", class="done"/>');

    form.data('tree', this);
    form.submit(function(e) {
      e.preventDefault();
      node = {};
      node[form.find('.name').val()] = form.find('.value').val();
      form.data('tree').addNode(node);
    });

    $(this.element).append(this.tree_html);
    $(this.element).append(form);
  },

  treeData: function() {
    return this.data;
  },

  addNode: function(data) {
    $.extend(this.data, data);
    for(name in data) {
      var leaf = $("<li class='leaf'><span class='name'></span><span class='value'</span></li>");
      leaf.find('.name').html(name);
      leaf.find('.value').html(data[name]);
      this.tree_html.append(leaf);
    }
  }
});
