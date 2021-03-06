using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DirectionAnimationController : MonoBehaviour
{
    
    [SerializeField]
    private CharacterAnimationController anim;

    private bool isRunning = false;
    [SerializeField]
    private float speed = 1f;
    [SerializeField]
    private float runningMultiplier = 2f;

    [SerializeField]
    private Transform lookAtPointer;
    private Vector3 pPos;

    private bool isJumping = false;
    [SerializeField]
    private Transform onFloorPointer;

    private float x = 0;
    private float y = 0;

    private float groundDistance = 0.4f;
    [SerializeField] LayerMask groundMask;
    private bool isGrounded = false;

    // Start is called before the first frame update
    void Start()
    {
        pPos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        if (!isJumping)
        {
            x = Input.GetAxis("Horizontal");
            y = Input.GetAxis("Vertical");
        }

        
       


        lookAtPointer.transform.localPosition = Vector3.Lerp(new Vector3(x, 0, y), lookAtPointer.transform.localPosition, 0.5f);
        //anim.transform.LookAt(lookAtPointer);
        if (Mathf.Abs(x) > 0 || Mathf.Abs(y) > 0)
        {
            var rotation = Quaternion.LookRotation(lookAtPointer.position - anim.transform.position);
            anim.transform.rotation = Quaternion.Slerp(anim.transform.rotation, rotation, Time.deltaTime * 8f);

        }


        isRunning = Input.GetKey(KeyCode.LeftShift);


       
        RaycastHit hit;
        Ray ray = new Ray();
        ray.direction = -this.onFloorPointer.up;
        ray.origin = this.onFloorPointer.position;

        

        if (!Physics.Raycast(ray, out hit))
        {
            anim.StartFall();
        }
        else
        {
            if (hit.distance > 0.5f)
                anim.StartFall();
            else
                anim.StopFall();

        }
        if (Input.GetMouseButtonDown(0))
        {
            anim.Attack();
        }
    }
}
