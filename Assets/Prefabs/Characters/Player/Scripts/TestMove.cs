using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMove : MonoBehaviour
{
    [SerializeField] private CharacterController controller;
    [SerializeField] private CharacterAnimationController anim;

    // Walk/Run variables
    [SerializeField] private float speed = 1f;
    [SerializeField] private float runningMultiplier = 2f;
    private bool isRunning = false;

    [SerializeField] private Transform lookAtPointer;
    private Vector3 pPos;

    // Jump variables
    private bool isJumping = false;
    [SerializeField] public float jumpSpeed = 3f;
    [SerializeField] public float runningJumpSpeed = 4f;
    private float ySpeed;
    private float originalStepOffset;
    private float jumpTimer;

    [SerializeField] private Transform onFloorPointer;

    private float horizontalInput = 0;
    private float verticalInput = 0;
    [SerializeField] private Camera cam;

    
    public bool lockInput = false;
    private Vector3 targ;
    private bool isTargeting = false;

    // Start is called before the first frame update
    void Start()
    {
        pPos = transform.position;
        originalStepOffset = controller.stepOffset;
    }

    // Update is called once per frame
    void Update()
    {
        // If player is not jumping, gets the inputs
        if (!isJumping)
        {
            horizontalInput = Input.GetAxis("Horizontal");
            verticalInput = Input.GetAxis("Vertical");
        }

        // Handle jumping
        ySpeed += Physics.gravity.y * Time.deltaTime;

        // Check if player is running
        isRunning = Input.GetKey(KeyCode.LeftShift);

        jumpTimer += Time.deltaTime;
        // If controller is grounded
        if (controller.isGrounded)
        {
            // enable default step offset
            controller.stepOffset = originalStepOffset;

            ySpeed = -.5f; // reset gravity 

            if (Input.GetButtonDown("Jump") && jumpTimer > 1f)
            {
                jumpTimer = 0;

                if (isRunning)
                    ySpeed = runningJumpSpeed; // set y value to the jump speed
                else
                    ySpeed = jumpSpeed; // set y value to the jump speed
            }
        }
        else
        {
            // disable step offset when not grounded
            controller.stepOffset = 0;
        }

        Vector3 maskedForward = new Vector3(cam.transform.forward.x, 0, cam.transform.forward.z);
        Vector3 maskedRight = new Vector3(cam.transform.right.x, 0, cam.transform.right.z);
        // Find the movement vector 
        Vector3 movementVector = maskedForward * verticalInput * speed;
        movementVector += maskedRight * horizontalInput * speed;

        // If the player is running, multiply vector by running multiplier
        if (isRunning)
        {
            movementVector *= runningMultiplier;
        }

        // Update vectors y value based on gravity/jumping speed
        movementVector.y = ySpeed;

        // Move player
        if (!lockInput)
            controller.Move(movementVector * Time.deltaTime);
        else if(this.isTargeting)
        {
            this.controller.transform.position = Vector3.MoveTowards(this.controller.transform.position,this.targ,Time.deltaTime*speed);
            if (Vector3.Distance(this.controller.transform.position, this.targ) < 0.4f)
            {
                this.targ = this.transform.position;
                this.lockInput = false;
                this.isTargeting = false;
            }
        }

        // Rotate player 
        //lookAtPointer.transform.localPosition = Vector3.Lerp(new Vector3(cam.transform.forward.x*horizontalInput, 0, cam.transform.forward.y*verticalInput),lookAtPointer.transform.localPosition,0.5f);
        //lookAtPointer.transform.localPosition = Vector3.Lerp(new Vector3(horizontalInput, 0, verticalInput), lookAtPointer.transform.localPosition, 0.5f);
        lookAtPointer.transform.localPosition = maskedForward * verticalInput + cam.transform.right * horizontalInput;

        if (Mathf.Abs(horizontalInput) > 0 || Mathf.Abs(verticalInput) > 0)
        {
            
            var rotation = Quaternion.LookRotation(lookAtPointer.position - anim.transform.position);
            
            anim.transform.rotation = Quaternion.Slerp(anim.transform.rotation, rotation, Time.deltaTime * 8f);
           
        }

        // HandleAnim(x, y);
        pPos = controller.transform.position;

        // Check if player is grounded, play falling animation if not grounded
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
            if (hit.distance > 1f)
                anim.StartFall();
            else
                anim.StopFall();
        }
        if (Input.GetMouseButtonDown(0))
        {
            anim.Attack();
        }

    }

    public void MoveTowards(Vector3 pos)
    {
        this.lockInput = true;
        this.targ = pos;
        this.isTargeting = true;
        
    }
    /// <summary>
    /// Example as how to implement the character animation controller outside the script.
    /// </summary>
    /// <param name="x"></param>
    /// <param name="y"></param>
    private void HandleAnim(float x, float y)
    {
        if (Vector3.Distance(controller.transform.position, pPos) > Time.deltaTime * speed * 0.8f)
        {
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

        if (Input.GetButtonDown("Jump") && jumpTimer > 1f)
        {
            anim.Jump(false);
        }
        if (Input.GetMouseButtonDown(0))
        {
            anim.Attack();
        }
    }
}
