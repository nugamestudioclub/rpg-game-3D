using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloorCollapseComponent : MonoBehaviour
{
    [SerializeField]
    private float rotateMag = 1f;
    private Rigidbody rb;
    private bool released = false;

    private float rotateX;
    private float rotateY;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        
        this.rotateMag = Random.Range(-1, 1) * this.rotateMag;
        this.rotateX = Random.Range(-1, 1) * this.rotateMag;
        this.rotateY = Random.Range(-1, 1) * this.rotateMag;
    }

    public void Release()
    {
        rb.isKinematic = false;
        this.released = true;
    }

    // Update is called once per frame
    void Update()
    {
        if(this.released)
            this.transform.Rotate(this.rotateX, this.rotateY, 0);
    }
}
