using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionFollow : MonoBehaviour
{
    [SerializeField]
    private Transform player;
    private Vector3 cameraOffset;
    private float cameraOffsetMag;
   
    private float height;

    private RaycastHit hit;


    // Start is called before the first frame update
    void Start()
    {
        this.cameraOffset = transform.localPosition;
        height = this.transform.position.y - this.transform.parent.parent.transform.position.y;
        cameraOffsetMag = this.cameraOffset.magnitude;
        

    }
    float curDist;
    float maxDist;
    float offsetDist;
    [SerializeField]
    LayerMask layer;
    // Update is called once per frame
    void Update()
    {

        Vector3 curOffsetPos = cameraOffset.normalized * this.cameraOffsetMag;
        if (Physics.Linecast(this.transform.parent.parent.position, curOffsetPos,out hit))
        {

        }
        else{
            
        }
        

    }
}
