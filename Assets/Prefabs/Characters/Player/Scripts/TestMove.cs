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

    // Start is called before the first frame update
    void Start()
    {
        pPos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        float x = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Vertical");
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
        var rotation = Quaternion.LookRotation(lookAtPointer.position - anim.transform.position);
        anim.transform.rotation = Quaternion.Slerp(anim.transform.rotation, rotation, Time.deltaTime * 8f);

        if (Input.GetKeyDown(KeyCode.LeftShift))
        {
            isRunning = true;
        }



        HandleAnim(x, y);
        pPos = controller.transform.position;

    }

    private void HandleAnim(float x,float y)
    {
        if (Vector3.Distance(controller.transform.position,pPos)>Time.deltaTime*speed)
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
