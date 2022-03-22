using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    [SerializeField]
    private Transform target;
    private Vector3 offset;

    // Start is called before the first frame update
    void Start()
    {
        offset = this.transform.position - target.transform.position;
        print("Offset:" + offset);
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.position = target.transform.position + offset;
    }
}
