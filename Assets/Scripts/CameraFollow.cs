using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    private Camera cam;
    [SerializeField]
    private GameObject follow;

    private Vector3 offset;

    // Start is called before the first frame update
    void Start()
    {
        cam = GetComponent<Camera>();
        offset = this.transform.position - follow.transform.position;

    }

    // Update is called once per frame
    void Update()
    {
        this.transform.position = follow.transform.position + offset;
    }
}
