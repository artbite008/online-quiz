LinkedListNode = function(nodeValue, orderIndex, displayIndex){
    this.prevNode = null;//前驱指针
    this.nextNode = null;//后继指针 
    this.nodeValue = nodeValue;//节点值,保存questionId
    this.orderIndex = orderIndex;//不可见问题顺序标号
    this.displayIndex = displayIndex;//可见显示顺序标号，如果是note,此值为-1
}

LinkedList = function () {
    this.head = null;
    this.tail = null;
    this.length = 0;
}

LinkedList.prototype.getNodeByIndex = function(i) {
    //取得一个双向链表中位序为i的元素
    var returnValue = null;
    var currentNode = this.head;
    var currentIndex = 0;
    while ((currentNode != null) && (currentIndex <= i)) {
        //没有达到最后一个元素，并且位序小于或等于i
        if (currentIndex == i) {
            returnValue = currentNode.nodeValue;//如果序号相等则返回
        }
        currentIndex++;
        currentNode = currentNode.nextNode;//指向下一个元素
    }
    return returnValue;
}

LinkedList.prototype.getNodeByValue = function(nodeValue) {
    //取得一个双向链表中位序为i的元素
    var returnNode = null;
    var currentNode = this.head;
    while (currentNode != null) {
        if (currentNode.nodeValue == nodeValue) {
            returnNode = currentNode;//如果值相等则返回
            break;
        }
        currentNode = currentNode.nextNode;//指向下一个元素
    }
    return returnNode;
}

LinkedList.prototype.prior = function prior(specifiedNodeValue) {
    //取得一个双向链表中值为elem的前一个元素的
    var returnNode = null;
    var currentNode = this.head;
    while (currenNode != null) {
        if (currentNode.nodeValue == specifiedNodeValue) {
            //判断当前值是否与给定的值相等
            if (currentNode.prevNode != null) {
                //如果相同，并且不是第一个元素
                returnNode = currentNode.prevNode;//就将该元素的前一个元素返回
            }
            break;//任务完成，退出循环
        }
        currentNode = currentNode.nextNode;//指向下一个元素
    }
    return returnNode;
}

LinkedList.prototype.next = function (specifiedNodeValue) {
    //取得一个双向链表中值为elem的后一个元素的值
    var returnNode = null;
    var currentNode = this.head;
    while (currentNode != null) {
        //只要没有到达尾指针
        if (currentNode.nodeValue == specifiedNodeValue) {
            //如果与给定的元素相等
            if (currentNode.nextNode != null) {
                //并且不是最后一个元素
                returnNode = currentNode.nextNode;//将该元素的下一个元素的值返回
            }
            break;// 任务完成，退出循环
        }
        currentNode = currentNode.nextNode;//指向下一个元素
    }
    return returnNode;
}


//在尾部追加
LinkedList.prototype.append = function (nodeValue, orderIndex, displayIndex) {
    if (this == null) return;

    if (typeof displayIndex == "undefined"){//如果是note，就不传这个值，因为note没有这个值
        displayIndex = -1;
    }    
    
    var newNode = new LinkedListNode(nodeValue, orderIndex, displayIndex);
    var currentNode = this.head;
    
    //当前链表为空
    if(currentNode == null){
        this.head = newNode;    
        this.tail = newNode;
    }else{
        this.tail.nextNode = newNode;
        newNode.preNode = this.tail;
        this.tail=newNode;
    }
    
    this.length++;

}

//在指定位置之前插入
LinkedList.prototype.insertBefore = function (specifiedIndex, nodeValue, orderIndex, displayIndex) {
    if (typeof displayIndex == "undefined"){//如果是note，就不传这个值，因为note没有这个值
        displayIndex = -1;
    }    
    //向一个双向链表的第specifiedIndex个位置插入元素
    var newNode = new LinkedListNode(nodeValue, orderIndex, displayIndex);
    var currentNode = this.head;
    var currentIndex = 0;
    while (currentNode != null) {
        //只要没有到达尾指针
        if (currentIndex == i) {
            //到达第i个元素
            if (currentNode.prevNode == null) {
                //第i个元素就是第一个元素
                newNode.nextNode = currenNode;//插入到原链表中的第一个元素之前
                currentNode.prevNode = newNode;
                this.head = nextNode;// 更新表头
            }
            else {
                //如果第i个元素不是原链表中的第一个元素
                //插入点前后元素的前后指针都要发生变化
                newNode.prevNode = currentNode.prevNode;
                newNode.nextNode = currentNode;
                currentNode.prevNode.nextNode = newNode;
                currentNode.prevNode = newNode;
            }
            this.length++;
            break;
        }
        currentIndex++;
        currentNode = currentNode.nextNode;//指向下一个元素
    }
}

LinkedList.prototype.remove = function(nodeValue) {
    if (this == null) return;
    
    var currentNode = this.head;
    while (currentNode != null) {
        //如果没有到达尾指针
        if (currentNode.nodeValue == nodeValue) {
            //到达了将要删除的元素的位置
            if (currentNode.nextNode == null) {
                //如果要删除的元素是最后一个元素
                currentNode.prevNode.nextNode = null;
            }
            else if (currentNode.prevNode == null) {
                //如果删除的元素是第一个元素
                currentNode.nextNode.prevNode = null;
                this.head = currentNode.nextNode;
            }
            else {
                //如果既不是第一个元素也不是最后一个元素,那么删除该元素
                currentNode.prevNode.nextNode = currentNode.nextNode;
                currentNode.nextNode.prevNode = currentNode.prevNode;
            }
            break;//任务完成，跳出循环
        }
        currentNode = currentNode.nextNode;//指向下一个元素
    }
}

LinkedList.prototype.toString = function(){
    if (this == null) return '';
    if(this.head == null) return '';
    
    var currentNode = this.head;
    var result = '';
    var index = 0;
    while (currentNode != null) {
        result = result + index + ": " + currentNode.nodeValue + ", " + currentNode.orderIndex + ", " + currentNode.displayIndex + " | ";
        currentNode = currentNode.nextNode;//指向下一个元素
        index++;
    }    
    
    return result;
}

function exchangeNode(linkedList, preNode, node){
    var node1 = preNode.preNode;
    var node2 = node.nextNode;
    
    if(node1==null){
        node.preNode = null;
        linkedList.head = node;
    }else{
        node1.nextNode = node;
        node.preNode = node1;        
    }
    
    if(node2==null){
        preNode.nextNode = null;
        linkedList.tail = preNode;
    }else{
        node2.preNode = preNode;
        preNode.nextNode = node2;        
    }

    
    node.nextNode = preNode;
    preNode.preNode = node;  
    
    return node;
}