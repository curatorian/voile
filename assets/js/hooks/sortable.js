let DragDrop = {
  mounted() {
    const hook = this;
    const container = this.el;

    this.sortable = new Sortable(container, {
      animation: 150,
      handle: ".cursor-move",
      ghostClass: "bg-blue-50",
      onEnd: function (evt) {
        if (evt.to === container) {
          const draggingId = evt.item.id.replace("prop-", "");
          const targetId = evt.to.children[evt.newIndex].id.replace(
            "prop-",
            ""
          );

          if (draggingId && targetId) {
            hook.pushEvent("drop", { target_id: targetId });
          }
        }
      },
    });
  },
  updated() {
    // Reinitialize Sortable after update
    if (this.sortable) {
      this.sortable.destroy();
    }

    const hook = this;
    const container = this.el;

    this.sortable = new Sortable(container, {
      animation: 150,
      handle: ".cursor-move",
      ghostClass: "bg-blue-50",
      onEnd: function (evt) {
        if (evt.to === container) {
          const draggingId = evt.item.id.replace("prop-", "");
          const targetId = evt.to.children[evt.newIndex].id.replace(
            "prop-",
            ""
          );

          if (draggingId && targetId) {
            hook.pushEvent("drop", { target_id: targetId });
          }
        }
      },
    });
  },
};

export default DragDrop;
