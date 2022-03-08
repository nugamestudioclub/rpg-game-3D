using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GroundDetection : MonoBehaviour
{
    private bool onGround = true;
    public bool OnGround { get { return onGround; } }
    private DirectionAnimationController controller;

    public void Start()
    {
        controller =this.transform.parent.GetComponent<DirectionAnimationController>();
       
    }

    private void OnTriggerEnter(Collider other)
    {
        this.onGround = true;
        
    }
    private void OnTriggerExit(Collider other)
    {
        this.onGround = false;
    }
}
