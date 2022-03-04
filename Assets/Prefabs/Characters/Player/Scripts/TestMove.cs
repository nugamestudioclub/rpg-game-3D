using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMove : MonoBehaviour
{
    [SerializeField]
    private CharacterController controller;
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

    // Start is called before the first frame update
    void Start()
    {
        pPos = transform.position;
    }

    private float x = 0;
    private float y = 0;

    // Update is called once per frame
    void Update()
    {
        if (!isJumping)
        {
            x = Input.GetAxis("Horizontal");
            y = Input.GetAxis("Vertical");
        }
       
        Vector3 movementVector = controller.transform.forward * y * Time.deltaTime*speed;
        movementVector += controller.transform.right * x * Time.deltaTime*speed;
        if (isRunning)
        {
            movementVector *= runningMultiplier;
        }

       
        controller.Move(movementVector);
        
        
        controller.SimpleMove(-controller.transform.up * -9.8f*Time.deltaTime);
        
        lookAtPointer.transform.localPosition = Vector3.Lerp(new Vector3(x, 0, y), lookAtPointer.transform.localPosition,0.5f);
        //anim.transform.LookAt(lookAtPointer);
        if (Mathf.Abs(x) > 0 || Mathf.Abs(y) > 0)
        {
            var rotation = Quaternion.LookRotation(lookAtPointer.position - anim.transform.position);
            anim.transform.rotation = Quaternion.Slerp(anim.transform.rotation, rotation, Time.deltaTime * 8f);

        }

        
        isRunning = Input.GetKey(KeyCode.LeftShift);
       

        HandleAnim(x, y);
        pPos = controller.transform.position;

    }



    private void HandleAnim(float x,float y)
    {
        if (Vector3.Distance(controller.transform.position,pPos)>Time.deltaTime*speed*0.8f)
        {
            print("Running!");
            if (Input.GetKey(KeyCode.LeftShift))
            {
                anim.Run();
            }
            else
            {
                anim.Walk();
            }


        }
        else
        {
            anim.Idle();
        }

        if (Input.GetButtonDown("Jump"))
        {
            anim.Jump(false);
        }
    }
}
