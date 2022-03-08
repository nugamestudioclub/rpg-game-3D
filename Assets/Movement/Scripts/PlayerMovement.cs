using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PlayerMovement : MonoBehaviour
{

    [Header("Movement")]
    public float moveSpeed;
    [SerializeField] float airMultiplier = 0.4f;
    public float walkSpeed = 22f; 
    public float sprintSpeed = 30f;
    [SerializeField] KeyCode sprintKey = KeyCode.LeftShift;

    [Header("Drag")]
    float groundDrag = 6f;
    [SerializeField] float airDrag = 2f;

    [Header("Keybinds")]
    [SerializeField] KeyCode jumpKey = KeyCode.Space; 

    float horizontalMovement;
    float verticalMovement;

    [Header("Ground Detection")]
    public float jumpForce = 5f;
    float playerHeight = 2f; 
    bool isGrounded;
    [SerializeField] LayerMask groundMask;
    float groundDistance = 0.4f;
    RaycastHit slopeHit; 

    Vector3 moveDirection;
    Vector3 slopeMoveDirection; 

    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    { 
        rb = GetComponent<Rigidbody>();
        rb.freezeRotation = true;
    }

    // Update is called once per frame
    void Update()
    {
        isGrounded = Physics.CheckSphere(transform.position - new Vector3(0, 1, 0), groundDistance, groundMask);

        HandleInput();
        ControlDrag();

        Debug.Log(isGrounded);

        if (Input.GetKeyDown(jumpKey) && isGrounded)
        {
            // Jump
            Jump();
        }

        // calculate where to move when on slope based on normals angle
        slopeMoveDirection = Vector3.ProjectOnPlane(moveDirection, slopeHit.normal);
    }

    void Jump()
    {
        rb.AddForce(transform.up * jumpForce, ForceMode.Impulse);
    }

    private bool OnSlope()
    {
        if (Physics.Raycast(transform.position, Vector3.down, out slopeHit, playerHeight / 2 + 0.5f))
        {
            // If the vector is not up, we are on a slope
            if (slopeHit.normal != Vector3.up)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        return false;
    }


    void ControlDrag()
    {
        if (isGrounded)
        {
            rb.drag = groundDrag;
        }
        else
        {
            rb.drag = airDrag;
        }
    }

    void HandleInput()
    {
        // Get the input, 1 or -1 for left/right up/down
        horizontalMovement = Input.GetAxisRaw("Horizontal");
        verticalMovement = Input.GetAxisRaw("Vertical");

        // use transform. to move the player relative to where they are looking
        moveDirection = transform.forward * verticalMovement + transform.right * horizontalMovement;
    }

    
    private void FixedUpdate()
    {
        MovePlayer();
    }

    private void MovePlayer()
    {
        if (Input.GetKey(sprintKey))
            moveSpeed = sprintSpeed;
        else
            moveSpeed = walkSpeed;

        if (isGrounded && !OnSlope())
        {
            // normalize move direction so it never goes past 1 on diagonal
            rb.AddForce(moveDirection.normalized * moveSpeed, ForceMode.Acceleration);
        }
        else if (isGrounded && OnSlope())
        {
            rb.AddForce(slopeMoveDirection.normalized * moveSpeed, ForceMode.Acceleration);
        }
        else  if (!isGrounded)
        {
            rb.AddForce(moveDirection.normalized * moveSpeed * airMultiplier, ForceMode.Acceleration);
        }
    }
}
