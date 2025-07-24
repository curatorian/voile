let DragDrop = {
  mounted() {
    this.initSortable();
  },

  updated() {
    // Reinitialize Sortable after update
    if (this.sortable) {
      this.sortable.destroy();
    }
    this.initSortable();
  },

  initSortable() {
    const hook = this;
    const container = this.el;

    this.sortable = new Sortable(container, {
      animation: 150,
      handle: ".cursor-move",
      ghostClass: "bg-blue-50",
      dragClass: "opacity-50",
      onStart: function (evt) {
        // Store the dragging item ID
        hook.draggingId = evt.item.id;
        console.log("Drag start:", hook.draggingId);
      },
      onEnd: function (evt) {
        if (evt.to === container && evt.oldIndex !== evt.newIndex) {
          console.log(
            "Drag end - old index:",
            evt.oldIndex,
            "new index:",
            evt.newIndex
          );
          console.log("Dragged item:", evt.item.id);

          // Send the reorder event with indices instead of trying to match IDs
          hook.pushEvent("reorder_by_index", {
            old_index: evt.oldIndex,
            new_index: evt.newIndex,
          });
        }
        hook.draggingId = null;
      },
    });
  },

  destroyed() {
    if (this.sortable) {
      this.sortable.destroy();
    }
  },
};

export default DragDrop;
