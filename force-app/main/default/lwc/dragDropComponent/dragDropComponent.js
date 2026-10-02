import { LightningElement } from 'lwc';

export default class DragDropComponent extends LightningElement {
    items = [
        { id: '1', label: 'Item A' },
        { id: '2', label: 'Item B' },
        { id: '3', label: 'Item C' }
    ];

    droppedItems = [];

    handleDragStart(event) {
        const itemId = event.target.dataset.id;
        event.dataTransfer.setData('text/plain', itemId);
    }

    handleDragOver(event) {
        event.preventDefault();
    }

    handleDrop(event) {
        event.preventDefault();
        const itemId = event.dataTransfer.getData('text/plain');
        const item = this.items.find(i => i.id === itemId);
        if (item && !this.droppedItems.find(i => i.id === itemId)) {
            this.droppedItems = [...this.droppedItems, item];
        }
    }
}