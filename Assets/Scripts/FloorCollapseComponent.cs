using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloorCollapseComponent : MonoBehaviour
{
    [SerializeField]
    private float rotateMag = 1f;
    private Rigidbody rb;
    private Collider col;
    private bool released = false;

    private float rotateX;
    private float rotateY;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        col = GetComponent<Collider>();
        
        this.rotateMag = Random.Range(-1, 1) * this.rotateMag;
        this.rotateX = Random.Range(-1, 1) * this.rotateMag;
        this.rotateY = Random.Range(-1, 1) * this.rotateMag;
    }

    public void Release()
    {
        col.enabled = false;
        rb.isKinematic = false;
        
        this.released = true;
    }

    public void Disable()
    {
        this.gameObject.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if(this.released)
            this.transform.Rotate(this.rotateX, this.rotateY, 0);
    }
}
