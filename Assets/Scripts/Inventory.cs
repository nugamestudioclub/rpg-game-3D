using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    public List<Interactable> items;
    public List<bool> isFull;
    private int inventorySize = 10;
    private int currCapacity = 0; 

    public void Start()
    {
        items = new List<Interactable>();
        isFull = new List<bool>();
    }

    public void addItem(Interactable item)
    {
        // check there is an empty space
        if (currCapacity < inventorySize)
        {
            items.Add(item);
            currCapacity += 1; 
        }
    }

    public void removeItem(Interactable item)
    {
        items.Remove(item);
        currCapacity -= 1;
    }

    public void Update()
    { 
        if (Input.GetKeyDown(KeyCode.F) && (currCapacity >= 1))
        {
            items.Remove(items[0]); 
        }
    }
}
