using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interactable : MonoBehaviour
{
 
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            Inventory playerInventory = collision.gameObject.GetComponent<Inventory>();
            playerInventory.addItem(this);
            gameObject.SetActive(false);
        }
        
    }

    
}
