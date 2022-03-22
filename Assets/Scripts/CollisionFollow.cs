using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionFollow : MonoBehaviour
{
    [SerializeField]
    private Transform player;
    private Vector3 startOffset;
    private Vector3 curOffset;
    [SerializeField]
    private float closeOffset = 0.3f;


    // Start is called before the first frame update
    void Start()
    {
        

        startOffset = this.transform.position - player.position;
        curOffset = startOffset;
        

    }
    float curDist;
    float maxDist;
    float offsetDist;
    [SerializeField]
    LayerMask layer;
    // Update is called once per frame
    void Update()
    {
        Ray ray = new Ray();
        ray.origin = player.transform.position;
        ray.direction = this.transform.position - player.transform.position;
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit,layer))
        {
            curDist = Vector3.Distance(hit.point, player.transform.position);
            maxDist = Vector3.Distance(this.startOffset + player.transform.position, player.transform.position);
            offsetDist = Vector3.Distance(curOffset + player.transform.position, player.transform.position);
            if (curDist <= offsetDist)
            {
                curOffset = startOffset.normalized * Mathf.Clamp(curDist-this.closeOffset,0.0001f,maxDist);

            }
            else
            {
                curOffset = startOffset.normalized * (Mathf.Clamp(curDist - this.closeOffset, 0.0001f, maxDist));
            }

        }
        this.transform.localPosition = curOffset;

    }
}
